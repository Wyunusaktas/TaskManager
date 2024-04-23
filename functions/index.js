const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationOnDocumentChange = functions.firestore
    .document('projects/{projectId}')
    .onWrite(async (change, context) => {
        const dataBefore = change.before.data();
        const dataAfter = change.after.data();
        const projectId = context.params.projectId;

        const assignedEmail = dataAfter ? dataAfter.assignedTo : dataBefore.assignedTo;

        const tokensSnapshot = await admin.firestore().collection('Tokens').where('email', '==', assignedEmail).get();
        const tokens = tokensSnapshot.docs.map(doc => doc.data().token);

        let message;
        if (!dataAfter) {
            message = {
                notification: {
                    title: 'New Notification',
                    body: `Your Task named ${projectId} has been deleted.`,
                }
            };
        } else if (dataBefore && dataAfter && JSON.stringify(dataBefore) !== JSON.stringify(dataAfter)) {
            message = {
                notification: {
                    title: 'New Notification',
                    body: ` Your Task named ${projectId} has been updated..`,
                }
            };
        } else if (!dataBefore && dataAfter) {
            message = {
                notification: {
                    title: 'New Notification',
                    body: `You have a new task named ${projectId} .`,
                }
            };
        }

        try {
            // Çoklu cihazlara bildirim gönder
            const response = await admin.messaging().sendMulticast({ ...message, tokens });
            console.log('Bildirimler gönderildi:', response);

            // Her bildirim için ayrı bir dokümantasyon oluştur
            const notificationsCollection = admin.firestore().collection('Notifications');
            const batch = admin.firestore().batch(); // Toplu yazma işlemi için bir batch oluştur

            tokens.forEach(token => {
                // Bildirimi gönderilen cihaz için bir doküman oluştur
                const notificationDocRef = notificationsCollection.doc(); // Otomatik olarak bir ID oluştur
                batch.set(notificationDocRef, {
                    title: message.notification.title,
                    body: message.notification.body,
                    assignedEmail: assignedEmail,
                    timestamp: admin.firestore.FieldValue.serverTimestamp()
                });
            });

            // Batch işlemi gerçekleştir
            await batch.commit();
        } catch (error) {
            console.error('Bildirim gönderilirken hata oluştu:', error);
        }

        return null;
    });
