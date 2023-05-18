import PropTypes from 'prop-types';
import React, { useState } from 'react';
import {Chart} from "react-google-charts";
//import style from './HelloWorld.module.css';


const ExampleCalendarChart = () => {

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
            id: "Won/Loss",
        },
    ]

    const data = [
        types,
        [new Date(2012, 3, 13), 37032],
        [new Date(2012, 3, 14), 38024],
        [new Date(2012, 3, 15), 38024],
        [new Date(2012, 3, 16), 38108],
        [new Date(2012, 3, 17), 38229],
        // Many rows omitted for brevity.
        [new Date(2013, 9, 4), 38177],
        [new Date(2013, 9, 5), 38705],
        [new Date(2013, 9, 12), 38210],
        [new Date(2013, 9, 13), 38029],
        [new Date(2013, 9, 19), 38823],
        [new Date(2013, 9, 23), 38345],
        [new Date(2013, 9, 24), 38436],
        [new Date(2013, 9, 30), 38447],

    ]

    return <Chart
        chartType="Calendar"
        width="100%"
        height="400px"
        data={data}
        options={options}
    ></Chart>
}


const HelloWorld = (props) => {
  const [name, setName] = useState(props.name);

  return (
    <div>
      <ExampleCalendarChart/>
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

export default HelloWorld;
