<template>
    <div>
      <b-form-input v-model="text" placeholder="Set rule..."></b-form-input>
    </div>
</template>

<script>
export default {
  name: "input-command-bar",
  props: {
    style: {
      type: String,
      default: "",
    },
  },
  data() {
      return {
        text: ''
      }
    }
};
</script>