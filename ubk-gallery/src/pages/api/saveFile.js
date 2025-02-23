import formidable from 'formidable';
import fs from 'fs';
import path from 'path';

export const config = {
  api: {
    bodyParser: false, // Disable body parsing for file uploads
  },
};

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method Not Allowed' });
  }

  const form = formidable({ 
    uploadDir: path.join(process.cwd(), 'public/uploads'), 
    keepExtensions: true,
    multiples: false
  });

  try {
    const [fields, files] = await form.parse(req);

    if (!files || !files.file || files.file.length === 0) {
      return res.status(400).json({ error: 'No file uploaded' });
    }

    if (!fields || !fields.messageId || fields.messageId.length === 0) {
      return res.status(400).json({ error: 'Missing messageId' });
    }

    const file = files.file[0];
    const messageId = fields.messageId[0];

    // Save file with messageId as the filename
    const newPath = path.join(form.uploadDir, `${messageId}${path.extname(file.originalFilename)}`);

    // Rename file
    await fs.promises.rename(file.filepath, newPath);

    res.status(200).json({ success: true, filePath: `/uploads/${messageId}${path.extname(file.originalFilename)}` });
  } catch (error) {
    console.error('File upload error:', error);
    res.status(500).json({ error: 'Failed to upload file' });
  }
}
