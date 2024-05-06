import { Controller } from "@hotwired/stimulus"
// if page gives error or chart doesn't load, make sure to run 
// bin/rails assets:precompile before reloading to avoid cached content

import { Chart, registerables } from "chart.js";
Chart.register(...registerables);

// Connects to data-controller="make-chart"
export default class extends Controller {
  static targets = ["stockChart"]
  static values = {
    labels: Array,
    data: Array
  }

  canvasContext() {
    return this.stockChartTarget.getContext('2d');
  }
  
  connect() {
    // console.log(this.stockChartTarget)
    // console.log(this.labelsValue)
    // console.log(this.dataValue)
    
    new Chart(this.canvasContext(),
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
    )
  }
}
