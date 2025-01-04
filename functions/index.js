// index.js
import { initializeApp } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import { onRequest } from 'firebase-functions/v2/https';
import nodemailer from 'nodemailer';
import cors from 'cors';
import { ApiServices } from './ApiServices.js';

initializeApp();
const db = getFirestore();
const corsMiddleware = cors({ origin: true });
// Configure Nodemailer using environment variables
const emailUser = process.env.EMAIL_USER || 'olayemi.abdullahi9585@gmail.com';
const emailPass = process.env.EMAIL_PASS || 'ktrrffyquubmrvim';

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: { user: emailUser, pass: emailPass },
});

function generateEmailTemplate(matchingJobs, unsubscribeUrl) {
    return `
        <!DOCTYPE html>
        <html>
        <head>
            <style>
                .container { max-width: 600px; margin: auto; font-family: Arial, sans-serif; }
                .header { background: linear-gradient(to right, #FFE0C2, #7FFFD4); padding: 20px; text-align: center; }
                .job-card { border: 1px solid #eee; padding: 15px; margin: 10px 0; border-radius: 5px; }
                .apply-button { background: #4CAF50; color: white; padding: 8px 15px; text-decoration: none; border-radius: 3px; display: inline-block; margin-top: 10px; }
                .footer { background: #f5f5f5; padding: 15px; text-align: center; font-size: 12px; }
                .unsubscribe { color: #666; text-decoration: underline; }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>Your Job Matches</h1>
                </div>
                ${matchingJobs.map(job => `
                    <div class="job-card">
                        <h3>${job.jobTitle || job.hlTitle}</h3>
                        <p>${job.locationName || job.location}</p>
                        <p>${job.salary ?? 'Competitive salary'}</p>
                        <a href="${job.url || job.jobUrl}" class="apply-button">Apply Now</a>
                    </div>
                `).join('')}
                <div class="footer">
                    <p>You received this email because you're subscribed to job alerts on Tuned Jobs.</p>
                    <p><a href="${unsubscribeUrl}" class="unsubscribe">Unsubscribe</a> from these alerts</p>
                </div>
            </div>
        </body>
        </html>
    `;
}
export const sendJobAlerts = onRequest({
    memory: '256MiB',
    region: 'us-central1',
}, (req, res) => {
    corsMiddleware(req, res, async () => {
          try {
                    const apiServices = new ApiServices();
                    const alertsSnapshot = await db.collection('jobAlerts').get();
                    const alerts = alertsSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));

                    const processedAlerts = await Promise.all(alerts.map(async (alert) => {
                        if (!alert.emailNotification) return null;

                        try {
                            const [cvJobs, reedJobs] = await Promise.all([
                                apiServices.getCvLibraryJob(alert.jobTitle, alert.location),
                                apiServices.getFilesApi(alert.jobTitle, alert.location)
                            ]);

                            const matchingJobs = [...cvJobs.slice(0, 2), ...reedJobs.slice(0, 1)];

                            if (matchingJobs.length === 0) return null;

                            const unsubscribeUrl = `https://your-app-url.com/unsubscribe?alertId=${alert.id}&email=${encodeURIComponent(alert.userEmail)}`;

                            const mailOptions = {
                                from: `Tuned Jobs <${emailUser}>`,
                                to: alert.userEmail,
                                subject: `Latest ${alert.jobTitle} Jobs in ${alert.location}`,
                                html: generateEmailTemplate(matchingJobs, unsubscribeUrl),
                            };\

                            await transporter.sendMail(mailOptions);
                            console.log(`Alert sent to ${alert.userEmail}`);
                            return { success: true, email: alert.userEmail };
                        } catch (error) {
                            console.error(`Error processing alert for ${alert.userEmail}:`, error);
                            return { success: false, email: alert.userEmail, error: error.message };
                        }
                    }));

                    const results = processedAlerts.filter(result => result !== null);

                    res.status(200).json({
                        message: 'Job alerts processed',
                        successful: results.filter(r => r.success).length,
                        failed: results.filter(r => !r.success).length,
                        details: results
                    });

                } catch (error) {
                    console.error('Error processing job alerts:', error);
                    res.status(500).json({
                        error: 'Failed to process job alerts',
                        details: error.message
                    });
                }
    });
});

export const handleUnsubscribe = onRequest({
    memory: '256MiB',
    region: 'us-central1',
}, (req, res) => {
    corsMiddleware(req, res, async () => {
        // Your existing handleUnsubscribe implementation...
          try {
                    const { alertId } = req.query;

                    await db.collection('jobAlerts').doc(alertId).update({
                        emailNotification: false,
                    });

                    res.send(`
                        <html>
                        <body style="text-align: center; font-family: Arial;">
                            <h2>Successfully Unsubscribed</h2>
                            <p>You will no longer receive job alerts for this search.</p>
                        </body>
                        </html>
                    `);
                } catch (error) {
                    console.error('Unsubscribe error:', error);
                    res.status(500).json({
                        error: 'Failed to unsubscribe',
                        details: error.message
                    });
                }
    });
});