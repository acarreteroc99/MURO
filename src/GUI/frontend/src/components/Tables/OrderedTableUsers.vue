<template>
  <div>
    <md-table v-model="users" :table-header-color="tableHeaderColor">
      <md-table-row>
        <md-table-head>ID</md-table-head>
        <md-table-head>Name</md-table-head>
        <md-table-head>Username</md-table-head>
      </md-table-row>
      <md-table-row v-for="(data, index) in jsonContent" :key="index">  
          <md-table-cell :md-label="ID">{{ index }}</md-table-cell>
          <md-table-cell :md-label="Name">{{ data.Name }}</md-table-cell>
          <md-table-cell :md-label="SAMAcc">{{ data.SAMAccountName }}</md-table-cell>
      </md-table-row>
    </md-table>
  </div>
</template>

<script>
import json from "../../../../../../json/AD_Info/users.json";
export default {
  name: "ordered-table-users",
  props: {
    tableHeaderColor: {
      type: String,
      default: "",
    },
  },
  data() {
    return {
      jsonContent: json,
    };
  },
};
</script>
