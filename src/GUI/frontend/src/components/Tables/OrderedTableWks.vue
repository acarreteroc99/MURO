<template>
  <div>
    <md-table v-model="users" :table-header-color="tableHeaderColor">
      <md-table-row>
        <md-table-head>ID</md-table-head>
        <md-table-head>Name</md-table-head>
        <md-table-head>OS</md-table-head>
      </md-table-row>
      <md-table-row v-for="(data, index) in jsonContent" :key="index">  
        <md-table-cell :md-label="ID">{{ index }}</md-table-cell>
        <md-table-cell :md-label="Name">{{ data.Name }}</md-table-cell>
        <md-table-cell :md-label="OperatingSystem">{{ data.OperatingSystem }}</md-table-cell>
      </md-table-row>
    </md-table>
  </div>
</template>

<script>
import json from "../../../../../../json/AD_Info/computers.json";
export default {
  name: "ordered-table-wks",
  props: {
    tableHeaderColor: {
      type: String,
      default: "",
    },
  },
  data() {
    return {
      jsonContent: json.wks,
    };
  },
};
</script>
