<script>
    import * as d3 from "d3";
    export let data;
    export let xScale;
    export let yScale;
    export let color;

    // Create an area generator
    const lineGenerator = d3.line()
        .x(d=>xScale(d.year))
        .y(d=>yScale(d.percent))
        .defined(d => d.percent !== null)
</script>

<path d={lineGenerator(data)} fill={"none"} stroke={color} stroke-width={3}/>
