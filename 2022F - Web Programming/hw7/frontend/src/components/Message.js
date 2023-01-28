import React from 'react'
import styled from 'styled-components'
import { Tag } from 'antd'

const MessageWrapper = styled.div`
	display: flex;
	align-items: center;
	flex-direction: ${({isMe}) => (isMe ? 'row-reverse' : 'row')};
	margin: 8px 0px;

	&p:first-child {
		margin: 0 5px;
	}
	&p:last-child {
		padding: 2px 5px;
		border-radius: 5px;
		background: #eee;
		color: gray;
		margin: auto 0;

	}
` // styled component 可以傳參數！這裡是為了讓自己的訊息顯示靠右


export const Message = ({name, message, isMe}) => {
	return (
		<MessageWrapper isMe={isMe}>
			<p><Tag color="blue">{name}</Tag>{message}</p>
		</MessageWrapper>
	)
}
export default Message;
