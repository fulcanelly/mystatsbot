import Chart from "react-google-charts";
import * as React from "react";



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



export const MessageCalendar = ({stats, chartEvents}) =>
    <Chart
        chartType="Calendar"
        width="100%"
        height="800px"
        data={[
            types,
            ...stats
        ]}
        options={options}
        chartEvents={chartEvents}
        />
