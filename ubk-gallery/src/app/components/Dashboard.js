import { ref, push, set, remove } from 'firebase/database';
import { useState, useCallback } from 'react';
import { db } from '../../lib/firebase';
import { VStack, Input, Textarea, Button, useToast, Box, Spinner, Switch, FormControl, FormLabel, Flex, Image } from '@chakra-ui/react';
import DatePicker from 'react-datepicker';
import { useDropzone } from 'react-dropzone';
import AWS from 'aws-sdk';
import 'react-datepicker/dist/react-datepicker.css'; // Ensure DatePicker styles are imported

export default function Dashboard() {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [date, setDate] = useState(new Date());
  const [file, setFile] = useState(null);
  const [isVisible, setIsVisible] = useState(true); // Default visibility is true
  const [isLoading, setIsLoading] = useState(false);
  const toast = useToast();

  const onDrop = useCallback(acceptedFiles => {
    if (acceptedFiles.length > 0) {
      setFile(acceptedFiles[0]); // Store only the first file
    }
  }, []);

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: 'image/*,video/*', // Accept images and videos
    maxFiles: 1, // Limit to one file
  });

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
    setIsLoading(true);

    // Extract year and month from the selected date
    const year = date.getFullYear();
    const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    const month = monthNames[date.getMonth()]; // Get month name

    // Format date as dd/mm/yyyy
    const formattedDate = `${String(date.getDate()).padStart(2, '0')}/${String(date.getMonth() + 1).padStart(2, '0')}/${year}`;
    // Create a new reference in Firebase under the correct year and month
    const newImageRef = push(ref(db, `gallery/${year}/${month}`));
    const messageId = newImageRef.key; // This is the unique ID from Firebase

    const AWS_ACCESS_KEY_ID="AKIAYQNJS3OYISRVBVGO"
    const AWS_REGION="ap-southeast-2"
    const AWS_SECRET_ACCESS_KEY="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"
    try {
      // Configure AWS S3
      const s3 = new AWS.S3({
        accessKeyId: AWS_ACCESS_KEY_ID,
        secretAccessKey: AWS_SECRET_ACCESS_KEY,
        region: AWS_REGION,
      });

      // Upload file to S3
      const s3Params = {
        Bucket: 'lumina-database/ubk-gallery',
        Key: `${messageId}_${file.name}`,
        Body: file,
        ContentType: file.type,
      };

      const uploadResult = await s3.upload(s3Params).promise();

      // Save metadata to Firebase Realtime Database
      await set(newImageRef, {
        title,
        description,
        date: formattedDate, // Use formatted date
        isVisible, // Save visibility state
        messageId, // Store message ID for consistency
        s3_url: uploadResult.Location, // Store the S3 URL
        media_type: file.type.startsWith('image/') ? 'photo' : 'video',
        fileName: `${messageId}_${file.name}`
      });

      toast({
        title: "Entry added successfully",
        status: "success",
        duration: 3000,
        isClosable: true,
      });

      // Reset form
      setTitle('');
      setDescription('');
      setDate(new Date());
      setFile(null);
      setIsVisible(true); // Reset visibility to default
    } catch (error) {
      console.error("Error adding entry:", error);

      // Remove the entry from Firebase if S3 upload fails
      await remove(newImageRef);
      toast({
        title: "Error adding entry",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <VStack as="form" onSubmit={handleSubmit} spacing={4} align="stretch" maxW="md" mx="auto" mt={8}>
      <Input
        placeholder="Title"
        value={title}
        onChange={(e) => setTitle(e.target.value)}
        size="md"
      />
      <Textarea
        placeholder="Description"
        value={description}
        onChange={(e) => setDescription(e.target.value)}
        size="md"
      />
      <Flex align="center" justify="space-between" border="1px solid" borderColor="gray.300" borderRadius="md" p={2}>
        <DatePicker
          selected={date}
          onChange={(date) => setDate(date)}
          className="react-datepicker__input-container"
          style={{ width: '100%' }}
        />
      </Flex>
      <Box {...getRootProps()} border="2px dashed" p={4} borderRadius="md" textAlign="center">
        <input {...getInputProps()} />
        {isDragActive ? (
          <p>Drop the files here ...</p>
        ) : (
          <p>Drag 'n' drop a file here, or click to select a file</p>
        )}
      </Box>
      {file && (
        <Box mt={2}>
          {file.type.startsWith('image/') ? (
            <Image src={URL.createObjectURL(file)} alt="Preview" boxSize="100px" objectFit="cover" />
          ) : (
            <video width="100" height="100" controls>
              <source src={URL.createObjectURL(file)} type={file.type} />
              Your browser does not support the video tag.
            </video>
          )}
        </Box>
      )}
      <Flex justify="flex-end" mt={2}>
        <FormControl display="flex" alignItems="center">
          <FormLabel htmlFor="visibility-switch" mb="0">
            Public
          </FormLabel>
          <Switch
            id="visibility-switch"
            isChecked={isVisible}
            onChange={(e) => setIsVisible(e.target.checked)}
            colorScheme="blue"
          />
        </FormControl>
      </Flex>
      <Button type="submit" isLoading={isLoading} colorScheme="blue" size="md">
        {isLoading ? <Spinner size="sm" /> : 'Submit'}
      </Button>
    </VStack>
  );
}
