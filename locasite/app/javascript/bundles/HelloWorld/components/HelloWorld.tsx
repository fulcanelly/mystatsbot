import PropTypes from 'prop-types';
import React, {useEffect, useRef, useState} from 'react';
import {Chart, ReactGoogleChartEvent} from "react-google-charts";
import './HelloWorld.module.css';
import {getPostsPerDay} from "../../api/tg_posts";

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


  return <>
      <ExampleCalendarChart setSelected={setSelected}/>
      {selected && <h2>Currently selected: {JSON.stringify(selected)} </h2>}
  </>
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

            setSelected(selection)

            console.log(selection)

            if (selection[0].row) {
                console.log(stats[selection[0].row])
            }
        }
    }

    const today = new Date();
    const lastYear = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    const setup = async () => {
        const postsByDay = await getPostsPerDay(lastYear.toDateString(), today.toDateString())
        console.log(postsByDay)
        setStats(postsByDay.map(([day, count]) => [new Date(day), count]) ?? [])

    }

    useEffect(() => {
        console.log('x------->')
        //setup()
        setInterval(setup, 1000)
        // TODO use cables to watch for updates
    },[])

    return <Chart
        chartType="Calendar"
        width="100%"
        height="1000px"
        data={[
            types,
            ...stats
        ]}
        options={options}
        chartEvents={[selectEventHandler]}
        />
};



const HelloWorld = (props) => {
  const [name, setName] = useState(props.name);

  return (
    <div>
      <InfoCalendar/>
      <h3>Hello=, {name}!</h3>
      <hr />
      <form>
        <label className={"style.bright"} htmlFor="name">
          Say hello to:
          <input id="name" type="text" value={name} onChange={(e) => setName(e.target.value)} />
        </label>
      </form>
    </div>
  );
};

HelloWorld.propTypes = {
  name: PropTypes.string.isRequired, // this is passed from the Rails view
};

export default HelloWorld
