import { Modal, Form, Input, message } from "antd";

const ChatModal = ({ open, onCreate, onCancel }) => {
  const [form] = Form.useForm();
  return (
    <Modal
      open={open}
      title="Create a new chat room"
      cancelText="Cancel"
      okText="Create"
      onCancel={onCancel}
      onOk={() => {
        form
          .validateFields()
          .then((values) => { // values = {name: "..."}
            form.resetFields();
            onCreate(values);
          })
          .catch((e) => {
            window.alert(e);
          });
      }}
    >
      <Form form={form} layout="vertical" name="form_in_modal">
        <Form.Item
          name="name"
          label="Name"
          rules={[
            {
              required: true,
              message: "Error: Please enter the name of the person.",
            },
          ]}
        >
          <Input />
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default ChatModal;
