import { gql } from '@apollo/client';

export const CREATE_CHATBOX_MUTATION = gql`
	mutation createChatBox($from: String!, $to: String!) {
		createChatBox(from: $from, to: $to) {
			name
			messages {
				sender
				body
			}
		}
	}`;

export const CREATE_MESSAGE_MUTATION = gql`
	mutation createMessage($from: String!, $to: String!, $body: String!) {
		createMessage(from: $from, to: $to, body: $body) {
			sender
			body
		}
	}
`