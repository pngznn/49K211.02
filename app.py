from chatbot import chatbot

print("🤖 Chatbot đã sẵn sàng!\n")

while True:
    msg = input("Bạn: ")

    # thoát
    if msg.lower() == "exit":
        print("Bot: Tạm biệt!")
        break

    reply = chatbot(msg)
    print("Bot:", reply)