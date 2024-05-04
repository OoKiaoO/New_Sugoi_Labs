import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js"

// Connects to data-controller="make-chart"
export default class extends Controller {
  static targets = ["stockChart"]
  static values = {
    labels: Array,
    data: Array
  }
  
  connect() {
    console.log(this.labelsValue)
    console.log(this.dataValue)

    
    new Chart(
      this.stockChartTarget,
      {
        type: 'pie',
        data: {
          labels: this.labelsValue,
          datasets: [
            {
              data: this.dataValue,
              backgroundColor: [
                'rgba(234, 60, 182, 0.8)',
                'rgba(246, 135, 45, 0.8)',
                'rgba(95, 60, 234, 0.8)'
              ]
            }
          ]
        }
      }
    );
  }

  
  // if () {
  //   // const ctx = myChart.getContext('2d');
  //   if (ctx) {
  //     const myChart = new Chart(ctx, {
  //       type: 'pie',
  //       data: {
  //         labels: JSON.parse(ctx.canvas.dataset.labels),
  //         datasets: [{
  //           data: JSON.parse(ctx.canvas.dataset.data),
  //           backgroundColor: [
  //             'rgba(234, 60, 182, 0.8)',
  //             'rgba(246, 135, 45, 0.8)',
  //             'rgba(95, 60, 234, 0.8)'
  //           ]
  //         }]
  //       },
  //       });
  //   }
  // }
}
