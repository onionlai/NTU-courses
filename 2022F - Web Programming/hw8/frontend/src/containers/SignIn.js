import AppTitle from "../components/Title";
import LogIn from "../components/LogIn";
import { useChat } from "./hooks/useChat";

const SignIn = ({ me }) => {
  const {
    setMe,
    displayStatus,
    setSignedIn,
  } = useChat();

  const handleLogin = (name ) => {
    if (!name) {
      displayStatus({
        type: "error",
        msg: "Missing username",
      });
    } else {
      // requestSignIn();
      setSignedIn(true);
    }
  };
  return (
    <>
      <AppTitle />
      <LogIn
        me={me}
        setMe={setMe}
        onLogin={handleLogin}
      />
    </>
  );
};

export default SignIn;
