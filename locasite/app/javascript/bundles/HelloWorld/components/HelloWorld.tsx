import PropTypes from 'prop-types';
import React, {useEffect, useRef, useState} from 'react';
import {Chart, ReactGoogleChartEvent} from "react-google-charts";
import './HelloWorld.module.css';
import {getPostsPerDay} from "../../api/tg_posts";

const options = {
    title: "Red Sox Attendance",
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


const data = [
    types,
    [new Date(2012, 3, 13), 37032],
    [new Date(2012, 3, 14), 38024],
    [new Date(2012, 3, 15), 38024],
    [new Date(2012, 3, 16), 38108],
    [new Date(2012, 3, 17), 38229],
]


// const InfoCalendar = () => {
//
//     const [selected, setSelected] = useState(null)
//     const [chartState, setChartState] = useState()
//
//     const selectEventHandler = {
//         eventName: "select",
//         callback: ({chartWrapper}) => {
//             const chart = chartWrapper.getChart();
//             const selection = chart.getSelection();
//
//             setSelected(selection)
//         }
//     }
//
//      return <>
//           <Chart
//               state={{}}
//               chartType="Calendar"
//               width="100%"
//               height="400px"
//               data={data}
//               options={options}
//               chartEvents={[selectEventHandler]}
//           />
//         {selected && <h2>Currently selected: {JSON.stringify(selected)} </h2>}
//      </>
// }




const InfoCalendar = () => {

  const [selected, setSelected] = useState(null)


  return <>
      <ExampleCalendarChart setSelected={setSelected}/>
      {selected && <h2>Currently selected: {JSON.stringify(selected)} </h2>}
  </>
}


// Use the state and event handler in the ExampleCalendarChart component
const ExampleCalendarChart = ({ setSelected }) => {

    const [stats, setStats] = useState([])

    const selectEventHandler: ReactGoogleChartEvent = {
        eventName: "select",
        callback: ({chartWrapper}) => {
            const chart = chartWrapper.getChart();
            const selection = chart.getSelection();

            setSelected(selection)
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
        setup()
    },[])

    return <Chart
        chartType="Calendar"
        width="100%"
        height="400px"
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
