import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="make-chart"
export default class extends Controller {
  static targets = ["stockChart"]
  // TODO: implement stimulus values to get the chart data from html
  
  connect() {
    console.log("Hello from make-chart controller!")
  }

  
  if (myChart) {
    const ctx = myChart.getContext('2d');
    if (ctx) {
      const myChart = new Chart(ctx, {
        type: 'pie',
        data: {
          labels: JSON.parse(ctx.canvas.dataset.labels),
          datasets: [{
            data: JSON.parse(ctx.canvas.dataset.data),
            backgroundColor: [
              'rgba(234, 60, 182, 0.8)',
              'rgba(246, 135, 45, 0.8)',
              'rgba(95, 60, 234, 0.8)'
            ]
          }]
        },
        });
    }
  }
}
