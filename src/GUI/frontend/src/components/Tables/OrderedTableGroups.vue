<template>
  <div>
    <md-table v-model="currentPage" :table-header-color="tableHeaderColor">
      <md-table-row>
        <md-table-head>ID</md-table-head>
        <md-table-head>Name</md-table-head>
      </md-table-row>
      <md-table-row v-for="(data, index) in jsonContent" :key="index">
        <md-table-cell :md-label="ID">{{ index }}</md-table-cell>
        <md-table-cell :md-label="Name">{{ data.Name }}</md-table-cell>
      </md-table-row>
    </md-table>
    <md-table-pagination
      :md-size="5"
      :md-page="1"
      :md-page-options="[5, 10, 25, 50]"
      @pagination="onPagination">
	  </md-table-pagination>
  </div>
</template>

<script>
import json from "../../../../../../json/AD_Info/groups.json";
export default {
  name: "ordered-table-groups",
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
