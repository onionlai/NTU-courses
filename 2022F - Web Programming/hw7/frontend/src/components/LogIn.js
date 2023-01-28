import { Input, Space, Button, Form } from "antd";
import { UserOutlined } from "@ant-design/icons";

const LogIn = ({ me, setMe, password, setPassword, onLogin }) => {
  const [form] = Form.useForm();
  form.setFieldsValue({username: me});
  return (
    // <Space direction="vertical" align="center">
    <Form align="center" form={form}>
      <Form.Item name="username" >
        <Input
          size="large"
          style={{ width: 300 }}
          prefix={<UserOutlined />}
          placeholder="Enter your name"
          value={me}
          onChange={(e) => setMe(e.target.value)}
        ></Input>
      </Form.Item>
      <Form.Item name="password">
        <Input.Password
          size="large"
          style={{ width: 300 }}
          placeholder="Enter your password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
      </Form.Item>
      <Form.Item>
        <Button
          type="primary"
          htmlType="submit"
          onClick={() => onLogin(me, password)}
        >
          LogIn
        </Button>
      </Form.Item>
    </Form>
  );
};

export default LogIn;
