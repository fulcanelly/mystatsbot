import * as React from "react";
import { getPostsPerDay } from "../api/tg_posts";
import { useEffect, useState } from "react";
import { MessageCalendar } from "./MessageCalendar";


export const ChatDetailed = (chat) => {
    const [chatInfo, setChatInfo] = useState([])

    useEffect(() => {
        getPostsPerDay({ chatId: chat.id }).then(setChatInfo)
        console.log()
    }, [])

    return <>
        Messages with {chat.first_name}
        <MessageCalendar stats={chatInfo} chartEvents={[]}/>
    </>
}

