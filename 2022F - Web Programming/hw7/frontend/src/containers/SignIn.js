import AppTitle from "../components/Title";
import LogIn from "../components/LogIn";
import { useChat } from "./hooks/useChat";

const SignIn = ({ me }) => {
  const {
    setMe,
    displayStatus,
    password,
    setPassword,
    requestSignIn,
  } = useChat();

  const handleLogin = (name, password) => {
    if (!name || !password) {
      displayStatus({
        type: "error",
        msg: "Missing username or password",
      });
    } else {
      requestSignIn();
    }
  };
  return (
    <>
      <AppTitle />
      <LogIn
        me={me}
        setMe={setMe}
        password={password}
        setPassword={setPassword}
        onLogin={handleLogin}
      />
    </>
  );
};

export default SignIn;
