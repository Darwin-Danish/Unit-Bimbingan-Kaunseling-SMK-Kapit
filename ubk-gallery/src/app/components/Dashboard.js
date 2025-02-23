import { useState, useCallback } from 'react';
import { VStack, Input, Textarea, Button, useToast, Box } from '@chakra-ui/react';
import { useDropzone } from 'react-dropzone';
import DatePicker from 'react-datepicker';
import "react-datepicker/dist/react-datepicker.css";
import { auth, db, storage } from '../../lib/firebase';
import { ref, push, set } from 'firebase/database';
import { ref as storageRef, uploadBytes, getDownloadURL } from 'firebase/storage';

export default function Dashboard() {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [date, setDate] = useState(new Date());
  const [isPublic, setIsPublic] = useState(true);
  const [file, setFile] = useState(null);
  const toast = useToast();

  const onDrop = useCallback(acceptedFiles => {
    setFile(acceptedFiles[0]);
  }, []);

  const { getRootProps, getInputProps, isDragActive } = useDropzone({ onDrop });

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!file) {
      toast({
        title: "No file selected",
        status: "error",
        duration: 3000,
        isClosable: true,
      });
      return;
    }

    try {
      // Upload file to Firebase Storage
      const fileRef = storageRef(storage, `images/${file.name}`);
      await uploadBytes(fileRef, file);
      const fileUrl = await getDownloadURL(fileRef);

      // Save data to Firebase Realtime Database
      const newImageRef = push(ref(db, 'gallery'));
      await set(newImageRef, {
        title,
        description,
        date: date.toISOString(),
        isPublic,
        fileUrl,
      });

      toast({
        title: "Image uploaded successfully",
        status: "success",
        duration: 3000,
        isClosable: true,
      });

      // Reset form
      setTitle('');
      setDescription('');
      setDate(new Date());
      setIsPublic(true);
      setFile(null);
    } catch (error) {
      console.error("Error uploading image:", error);
      toast({
        title: "Error uploading image",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  };

  return (
    <VStack as="form" onSubmit={handleSubmit} spacing={4} align="stretch">
      <Input
        placeholder="Title"
        value={title}
        onChange={(e) => setTitle(e.target.value)}
      />
      <Textarea
        placeholder="Description"
        value={description}
        onChange={(e) => setDescription(e.target.value)}
      />
      <DatePicker
        selected={date}
        onChange={(date) => setDate(date)}
        customInput={<Input />}
      />
      <div style={{ display: 'flex', alignItems: 'center' }}>
        <label htmlFor="is-public" style={{ marginRight: '10px', marginBottom: '0' }}>
          Make public?
        </label>
        <input
          type="checkbox"
          id="is-public"
          checked={isPublic}
          onChange={(e) => setIsPublic(e.target.checked)}
          style={{ width: '20px', height: '20px' }}
        />
      </div>
      <Box {...getRootProps()} borderWidth={2} borderStyle="dashed" borderColor="gray.300" p={5} textAlign="center">
        <input {...getInputProps()} />
        {
          isDragActive ?
            <p>Drop the files here ...</p> :
            <p>Drag 'n' drop some files here, or click to select files</p>
        }
      </Box>
      {file && <p>Selected file: {file.name}</p>}
      <Button type="submit">Upload</Button>
    </VStack>
  );
}