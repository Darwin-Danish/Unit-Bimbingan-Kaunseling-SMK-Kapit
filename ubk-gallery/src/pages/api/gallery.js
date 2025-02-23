import { TelegramClient } from "telegram";
import { StringSession } from "telegram/sessions";

const apiId = process.env.TELEGRAM_API_ID;
const apiHash = process.env.TELEGRAM_API_HASH;
const stringSession = new StringSession(process.env.TELEGRAM_STRING_SESSION);
const channelUsername = process.env.TELEGRAM_CHANNEL_USERNAME;

export default async function handler(req, res) {
  const { year, month } = req.query;

  try {
    const client = new TelegramClient(stringSession, apiId, apiHash, {
      connectionRetries: 5,
    });

    await client.connect();

    if (!year && !month) {
      // Fetch available years and months
      const messages = await client.getMessages(channelUsername, {
        limit: 1000, // Adjust as needed
      });

      const yearsAndMonths = messages.reduce((acc, message) => {
        const date = new Date(message.date * 1000);
        const year = date.getFullYear().toString();
        const month = date.toLocaleString('default', { month: 'long' });

        if (!acc[year]) {
          acc[year] = new Set();
        }
        acc[year].add(month);

        return acc;
      }, {});

      const result = Object.entries(yearsAndMonths).map(([year, months]) => ({
        year,
        months: Array.from(months),
      }));

      await client.disconnect();
      return res.status(200).json(result);
    }

    // Fetch images for specific year and month
    const messages = await client.getMessages(channelUsername, {
      limit: 100, // Adjust as needed
      filter: (message) => {
        const messageDate = new Date(message.date * 1000);
        return (
          messageDate.getFullYear().toString() === year &&
          messageDate.toLocaleString('default', { month: 'long' }) === month
        );
      },
    });

    const gallery = await Promise.all(messages.map(async (message) => {
      if (message.media) {
        const buffer = await client.downloadMedia(message.media, {});
        const base64 = buffer.toString('base64');
        return {
          id: message.id,
          date: new Date(message.date * 1000).toLocaleDateString(),
          title: message.message.split('\n')[0] || 'No Title',
          caption: message.message.split('\n').slice(1).join('\n') || '',
          mediaType: message.media.className === 'MessageMediaPhoto' ? 'photo' : 'document',
          imageData: `data:image/jpeg;base64,${base64}`,
        };
      }
      return null;
    }));

    await client.disconnect();

    res.status(200).json(gallery.filter(Boolean));
  } catch (error) {
    console.error("Error fetching gallery data:", error);
    res.status(500).json({ error: "Failed to fetch gallery data" });
  }
}
