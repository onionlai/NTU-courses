import { Input, Space, Button, Form } from "antd";
import { UserOutlined } from "@ant-design/icons";

const LogIn = ({ me, setMe, onLogin }) => {
  return (
    <>
      <Input
        size="large"
        style={{ width: 300 }}
        prefix={<UserOutlined />}
        placeholder="Enter your name"
        value={me}
        onChange={(e) => setMe(e.target.value)}
      ></Input>
      <Button
        type="primary"
        htmlType="submit"
        onClick={() => onLogin(me)}
      > LogIn </Button>
    </>
  );
};

export default LogIn;
