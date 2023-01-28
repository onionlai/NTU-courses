import { gql } from '@apollo/client';

export const CHATBOX_QUERY = gql`
	query chatbox($from: String!, $to: String!) {
		chatbox(from: $from, to: $to) {
			name
			messages {
				sender
				body
			}
		}
	}`;