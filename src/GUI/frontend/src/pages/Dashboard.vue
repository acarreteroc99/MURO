<template>
  <div class="content">
    <h3> Rule input </h3>
    <div style="text-align:center;">
      <input type="text" placeholder="Set rule..." v-model="command" style="color:grey; width:95%; height:40px;border-radius:7px;">
      <button type="button" v-on:click="sendCommand()" style="color:grey; width:3%; height:40px;border-radius:7px;">></button>
    </div>
    <br>
    <h3> Data available </h3>
    <div class="md-layout">
      <!-- 
        ===========================================================================================
                                    INSERT CHARTS + STATS CARDS IN HERE 
        =========================================================================================== 
      -->

      <div
        class="md-layout-item md-medium-size-100 md-xsmall-size-100 md-size-50"
      >
        <md-card>
          <md-card-header data-background-color="orange">
            <h4 class="title">Domains</h4>
            <p class="category">Existing domains within the AD</p>
          </md-card-header>
          <md-card-content>
            <ordered-table-domains
                      table-header-color="orange">
            </ordered-table-domains>
          </md-card-content>
        </md-card>
      </div>

      <div
        class="md-layout-item md-medium-size-100 md-xsmall-size-100 md-size-50"
      >
        <md-card>
          <md-card-header data-background-color="orange">
            <h4 class="title">Forests</h4>
            <p class="category">Existing forests within the AD</p>
          </md-card-header>
          <md-card-content>
            <ordered-table-forests table-header-color="orange"></ordered-table-forests>
          </md-card-content>
        </md-card>
      </div>

      <div
        class="md-layout-item md-medium-size-100 md-xsmall-size-100 md-size-50"
      >
        <md-card>
          <md-card-header data-background-color="orange">
            <h4 class="title">Groups</h4>
            <p class="category">Groups to which users may belong to in the AD</p>
          </md-card-header>
          <md-card-content>
            <ordered-table-groups table-header-color="orange"></ordered-table-groups>
          </md-card-content>
        </md-card>
      </div>

      <div
        class="md-layout-item md-medium-size-100 md-xsmall-size-100 md-size-50"
      >
        <md-card>
          <md-card-header data-background-color="orange">
            <h4 class="title">OUs</h4>
            <p class="category">Existing Organizational Units (OUs)</p>
          </md-card-header>
          <md-card-content>
            <ordered-table-ous table-header-color="orange"></ordered-table-ous>
          </md-card-content>
        </md-card>
      </div>

      <div
        class="md-layout-item md-medium-size-100 md-xsmall-size-100 md-size-50"
      >
        <md-card>
          <md-card-header data-background-color="orange">
            <h4 class="title">Users</h4>
            <p class="category">Users belonging to the company</p>
          </md-card-header>
          <md-card-content>
            <ordered-table-users table-header-color="orange"></ordered-table-users>
          </md-card-content>
        </md-card>
      </div>

      <div
        class="md-layout-item md-medium-size-100 md-xsmall-size-100 md-size-50"
      >
        <md-card>
          <md-card-header data-background-color="orange">
            <h4 class="title">Workstations</h4>
            <p class="category">Endpoints registered within the AD</p>
          </md-card-header>
          <md-card-content>
            <ordered-table-wks table-header-color="orange"></ordered-table-wks>
          </md-card-content>
        </md-card>
      </div>

      <!-- 
        ===========================================================================================
                                    INSERT TABLE WITH TASKS HERE
        =========================================================================================== 
      -->
    </div>
  </div>
</template>

<script>
import {
  // StatsCard,                       // Uncomment to use little boxes with numbers
  // ChartCard,                       // Uncomment to use line charts
  // NavTabsCard,                     // Uncomment to use table with tasks
  // NavTabsTable,                    // Uncomment to use table with tasks
  OrderedTableDomains,
  OrderedTableForests,
  OrderedTableGroups,
  OrderedTableOus,
  OrderedTableUsers,
  OrderedTableWks,
  // InputCommandBar,
} from "@/components";

export default {
  components: {
    // StatsCard,                     // Uncomment to use little boxes with numbers
    // ChartCard,                     // Uncomment to use line charts
    // NavTabsCard,                   // Uncomment to use table with tasks
    // NavTabsTable,                  // Uncomment to use table with tasks
    OrderedTableDomains,
    OrderedTableForests,
    OrderedTableGroups,
    OrderedTableOus,
    OrderedTableUsers,
    OrderedTableWks,
    // InputCommandBar,
  },
  data(){
    return{
      command: null
    }
  },
  methods:{
    submitCommand(){
      console.warn("values: ", this.command);
    },
    sendCommand(){
      let xhr = new XMLHttpRequest();
      xhr.open("GET", "https://localhost:8080/home");

      xhr.onreadystatechange = function () {
        if (xhr.readyState === 4) {
            console.log(xhr.responseText);
        }};

      xhr.send(this.command);
      console.warn("values: ", this.command);
    }

  },
  /*
  data() {
    return {
      dailySalesChart: {
        data: {
          labels: ["M", "T", "W", "T", "F", "S", "S"],
          series: [[12, 17, 7, 17, 23, 18, 38]],
        },
        options: {
          lineSmooth: this.$Chartist.Interpolation.cardinal({
            tension: 0,
          }),
          low: 0,
          high: 50, // creative tim: we recommend you to set the high sa the biggest value + something for a better look
          chartPadding: {
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
          },
        },
      },
      dataCompletedTasksChart: {
        data: {
          labels: ["12am", "3pm", "6pm", "9pm", "12pm", "3am", "6am", "9am"],
          series: [[230, 750, 450, 300, 280, 240, 200, 190]],
        },

        options: {
          lineSmooth: this.$Chartist.Interpolation.cardinal({
            tension: 0,
          }),
          low: 0,
          high: 1000, // creative tim: we recommend you to set the high sa the biggest value + something for a better look
          chartPadding: {
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
          },
        },
      },
      emailsSubscriptionChart: {
        data: {
          labels: [
            "Ja",
            "Fe",
            "Ma",
            "Ap",
            "Mai",
            "Ju",
            "Jul",
            "Au",
            "Se",
            "Oc",
            "No",
            "De",
          ],
          series: [
            [542, 443, 320, 780, 553, 453, 326, 434, 568, 610, 756, 895],
          ],
        },
        options: {
          axisX: {
            showGrid: false,
          },
          low: 0,
          high: 1000,
          chartPadding: {
            top: 0,
            right: 5,
            bottom: 0,
            left: 0,
          },
        },
        responsiveOptions: [
          [
            "screen and (max-width: 640px)",
            {
              seriesBarDistance: 5,
              axisX: {
                labelInterpolationFnc: function (value) {
                  return value[0];
                },
              },
            },
          ],
        ],
      },
    };
  },
  */
};
</script>
