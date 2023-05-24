import * as PropTypes from 'prop-types'
import * as React from 'react'
import {useEffect, useRef, useState} from 'react';
import {Chart, ReactGoogleChartEvent} from "react-google-charts";
import './HelloWorld.module.css';
import { getChatStatsOfDay, getPostsPerDay } from "../../api/tg_posts";
import { Card, CardContent, Link, Typography } from '@material-ui/core';

const options = {
    title: "Messages sent by You per day",
}

const types = [
    {
        type: "date",
        id: "Date",
    },
    {
        type: "number",
        id: "Event amount",
    }
]


const InfoCalendar = () => {
  const [selected, setSelected] = useState(null)
  const [dayInfo, setDayInfo] = useState([])

  useEffect(() => {
    if (!selected) return void setDayInfo([])
    getChatStatsOfDay(selected).then(setDayInfo)
  }, [selected])

  return <>
      <ExampleCalendarChart setSelected={setSelected}/>
      {selected && <h2>Currently selected: {JSON.stringify(selected)} </h2>}
      {dayInfo.map(info => <ChatStatsPerDay chatInfo={info}/>)}
  </>
}

const ChatStatsPerDay = ({ chatInfo }) => {
    const userurl = <Link
        target="_blank"
        rel="noopener noreferrer"
        href={`https://t.me/${chatInfo.username}`}>
            {chatInfo.username}
        </Link>

    const moreInfoLink = <Link href={`/chat_stats/${chatInfo.chat_id}`}>More info...</Link>

    return <Card>
        <CardContent>
            <Typography variant="h5" component="h2">
                {chatInfo.first_name} {chatInfo.username && userurl}
            </Typography>
            <Typography color="textSecondary" gutterBottom>
                Chat ID: {chatInfo.chat_id}
            </Typography>
            <Typography color="textSecondary" gutterBottom>
                Messages by Me: {chatInfo.post_count}
            </Typography>
            <Typography color="textSecondary" gutterBottom>
                {chatInfo.is_deleted && '<Deleted>'}
            </Typography>
            <Typography>
                {moreInfoLink}
            </Typography>
        </CardContent>
    </Card>

}


// TODO show detailed info of day on select
// Use the state and event handler in the ExampleCalendarChart component
const ExampleCalendarChart = ({ setSelected }) => {

    const [stats, setStats] = useState([])

    const selectEventHandler: ReactGoogleChartEvent = {
        eventName: "select",
        callback: ({chartWrapper}) => {
            const chart = chartWrapper.getChart();
            const selection = chart.getSelection() as any;

            if (selection[0].row) {
                const datestr = stats[selection[0].row][0]
                const date = new Date(datestr)
                setSelected(date)
            } else {
                setSelected(null)
            }
        }
    }

    const today = new Date();
    const lastYear = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    const setup = async () => {
        const postsByDay = await getPostsPerDay({})
        setStats(postsByDay.map(([day, count]) => [new Date(day), count]) ?? [])
    }

    useEffect(() => {
        setInterval(setup, 1000)
        // TODO use cables to watch for updates
    },[])

    return <Chart
        chartType="Calendar"
        width="100%"
        height="800px"
        data={[
            types,
            ...stats
        ]}
        options={options}
        chartEvents={[selectEventHandler]}
        />
};



const HelloWorld = (props) => {
  return (
    <div>
      <InfoCalendar/>
    </div>
  );
};

HelloWorld.propTypes = {
  name: PropTypes.string.isRequired, // this is passed from the Rails view
};

export default HelloWorld
