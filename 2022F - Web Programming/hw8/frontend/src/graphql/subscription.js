import { gql } from '@apollo/client';

export const MESSAGE_SUBSCRIPTION = gql`
	subscription subscribeChatBox ($from: String!, $to: String!){
		subscribeChatBox(from: $from, to: $to) {
			sender
			body
		}
	}
	`;