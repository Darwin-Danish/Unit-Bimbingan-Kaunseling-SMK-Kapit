import { useState, useEffect } from 'react';
import { Box, VStack, Heading, Button, useToast } from '@chakra-ui/react';
import { useRouter } from 'next/router';
import { getAuth, onAuthStateChanged, signOut } from 'firebase/auth';
import LoginForm from '../../app/components/LoginForm';
import Dashboard from '../../app/components/Dashboard';

export default function AdminPage() {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const router = useRouter();
  const toast = useToast();

  useEffect(() => {
    const auth = getAuth();
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      setUser(user);
      setLoading(false);
    });

    return () => unsubscribe();
  }, []);

  const handleLogout = async () => {
    try {
      const auth = getAuth();
      await signOut(auth);
      toast({
        title: "Logged out successfully",
        status: "success",
        duration: 3000,
        isClosable: true,
      });
      router.push('/');
    } catch (error) {
      console.error("Error logging out:", error);
      toast({
        title: "Error logging out",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  };

  const handleLoginSuccess = () => {
    toast({
      title: "Logged in successfully",
      status: "success",
      duration: 3000,
      isClosable: true,
    });
  };

  if (loading) {
    return <Box>Loading...</Box>;
  }
  if (!user) {
    return <LoginForm onLoginSuccess={handleLoginSuccess} />;
  }

  return (
    <Box p={5}>
      <VStack spacing={4} align="stretch">
        <Heading>Admin Dashboard</Heading>
        <Button onClick={handleLogout}>Logout</Button>
        <Dashboard />
      </VStack>
    </Box>
  );
}