import { Telegraf } from 'telegraf';
import fs from 'fs';
import path from 'path';

const bot = new Telegraf(process.env.TELEGRAM_BOT_TOKEN);
const CHANNEL_ID = process.env.TELEGRAM_CHANNEL_ID;
const UPLOAD_DIR = path.join(process.cwd(), 'public/uploads');

export default async function handler(req, res) {
  if (req.method === 'POST') {
    try {
      const { title, description, date, imageId } = req.body;
      const filePath = path.join(UPLOAD_DIR, imageId);

      const message = `
New Entry:
Title: ${title}
Description: ${description}
Date: ${new Date(date).toLocaleString()}
      `;

      await bot.telegram.sendMessage(CHANNEL_ID, message);

      if (fs.existsSync(filePath)) {
        await bot.telegram.sendDocument(CHANNEL_ID, { source: filePath });
        fs.unlinkSync(filePath); // Delete the file after sending
      }

      res.status(200).json({ success: true });
    } catch (error) {
      console.error('Error sending Telegram message:', error.message, error.stack);
      res.status(500).json({ success: false, error: 'Failed to send Telegram message' });
    }
  } else {
    res.setHeader('Allow', ['POST']);
    res.status(405).end(`Method ${req.method} Not Allowed`);
  }
}

// Ensure the bot is started
bot.launch();
