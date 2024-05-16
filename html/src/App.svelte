<script>
  import Line from "./lib/Line.svelte";
  import Xaxis from "./lib/Xaxis.svelte";
  import Yaxis from "./lib/Yaxis.svelte";
  import data from "./data/data.json";
  import * as d3 from "d3";

  //group data
  const countries = d3.group(data, (d) => d.country);

  const scaleFactor = 6;

  let width = 1920 / scaleFactor;
  let height = 1080 / scaleFactor;

  const margin = {
    top: (40 + 84) / scaleFactor,
    left: (140 + 84) / scaleFactor,
    bottom: (160 + 84) / scaleFactor,
    right: 84 / scaleFactor,
  };

  const xScale = d3
    .scaleLinear()
    .domain(d3.extent(data, (d) => d.year))
    .range([0, width - margin.left - margin.right]);

  const yScale = d3
    .scaleLinear()
    .domain([0, 100]) //use pop thousand otherwise hard to fit y axis labels
    .range([height - margin.bottom, 0]);


</script>

{#each [...countries] as [key, value]}
  <svg {width} {height}>
    <g transform="translate({margin.left},{margin.top})">
      <text x="10" y="-5" fill="black" font-weight="700">{key}</text>
      <text x={width-160} y="0" fill="black" font-size="12">{key==="AFRICA"?"(unit: thousands)":""}</text>
      <Line
        data={value.filter((d) => d.category == "male")}
        {xScale}
        {yScale}
        color={"#998ec3"}
      />
      <Line
        data={value.filter((d) => d.category == "female")}
        {xScale}
        {yScale}
        color={"#f1a340"}
      />
      <Xaxis {xScale} height={height - margin.bottom} />
      <Yaxis {yScale} />
    </g>
  </svg>
{/each}
