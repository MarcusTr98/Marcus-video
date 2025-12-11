package websocket;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import com.fasterxml.jackson.databind.ObjectMapper;

import dto.ChatMessageDTO;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;

@ServerEndpoint("/chat")
public class ChatEndpoint {

	private static Set<Session> users = Collections.synchronizedSet(new HashSet<>());
	private static ObjectMapper mapper = new ObjectMapper();

	@OnOpen
	public void onOpen(Session session) {
		users.add(session);
	}

	@OnMessage
	public void onMessage(String messageJson, Session session) throws IOException {
		try {
			ChatMessageDTO msg = mapper.readValue(messageJson, ChatMessageDTO.class);
			if (msg.getContent() == null || msg.getContent().trim().isEmpty())
				return;
			String jsonToSend = mapper.writeValueAsString(msg);
			for (Session s : users) {
				if (s.isOpen()) {
					s.getBasicRemote().sendText(jsonToSend);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@OnClose
	public void onClose(Session session) {
		users.remove(session);
	}

	@OnError
	public void onError(Session session, Throwable throwable) {
		throwable.printStackTrace();
	}
}