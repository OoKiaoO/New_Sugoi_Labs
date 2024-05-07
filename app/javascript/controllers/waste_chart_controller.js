import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js";
Chart.register(...registerables);

// if page gives error or chart doesn't load, make sure to run 
// bin/rails assets:precompile before reloading to avoid cached content

// Connects to data-controller="waste-chart"
export default class extends Controller {
  // static targets = ["wasteChart"]
  static values = {
    labels: Array,
    data: Array
  }

  canvasContext() {
    return this.element.getContext('2d');
  }

  connect() {
    console.log(this.element)
    console.log(this.labelsValue)
    console.log(this.dataValue)

    new Chart(this.canvasContext(),
      {
        type: 'bar',
        data: {
          labels: this.labelsValue,
          datasets: [
            {
              label: "Amount Wasted",
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
    )

  }

  // document.addEventListener('turbo:load', () => {
  //   const wasteChart = document.getElementById('wasteChart');
  //   if (wasteChart) {
  //     const ctx = wasteChart.getContext('2d');
  //     if (ctx) {
  //       const wasteChart = new Chart(ctx, {
  //         type: 'bar',
  //         data: {
  //           labels: JSON.parse(ctx.canvas.dataset.wastelabels),
  //           datasets: [{
  //             label: "Amount Wasted",
  //             data: JSON.parse(ctx.canvas.dataset.wastedata),
  //             backgroundColor: [
  //               'rgba(234, 60, 182, 0.2)',
  //               'rgba(246, 135, 45, 0.2)',
  //               'rgba(95, 60, 234, 0.2)'
  //             ]
  //           }]
  //         },
  //       });
  //     }
  //   }
}
