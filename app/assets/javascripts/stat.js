//= require flot/jquery.flot
//= require flot/jquery.flot.resize
//= require flot/jquery.flot.time

$(function () {

  var prevPoint, prevLabel;

  function setupFlotUser(data) {
    var userConfirmed   = statSetupDataset("Confirmed", "#E91E63");
    var userUnconfirmed = statSetupDataset("Unconfirmed", "#00BCD4");
    data.days.forEach(function(dt) {
      var date = getUnixTime(data.year, data.month, dt.id);
      userConfirmed.data.push([date, dt.count.confirmed]);
      userUnconfirmed.data.push([date, dt.count.unconfirmed]);
    });
    $.plot($("#stat-user"), [userConfirmed, userUnconfirmed], statSetupOptions());
    createTooltip("stat-user-tooltip");
    showTooltip($("#stat-user"), $("#stat-user-tooltip"));
  }

  function setupFlotNote(data) {
    var created = statSetupDataset("Created", "#E91E63");
    data.days.forEach(function(dt) {
      var date = getUnixTime(data.year, data.month, dt.id);
      created.data.push([date, dt.count]);
    });
    $.plot($("#stat-note"), [created], statSetupOptions());
    createTooltip("stat-note-tooltip");
    showTooltip($("#stat-note"), $("#stat-note-tooltip"));
  }

  function getUnixTime(y, m, d) {
    return new Date(y, m, d).getTime();
  }

  function statSetupDataset(label, color) {
    return {
      data: [],
      label: label,
      color: color,
      points: {fillColor: color, show: true},
      lines: {show: true}
    };
  }

  function statSetupOptions() {
    return {
      xaxes: [{mode: 'time', timeformat: "%d"}],
      yaxes: [{min: 0}],
      grid: {
          hoverable: true,
          autoHighlight: false,
          borderColor: '#f3f3f3',
          borderWidth: 1,
          tickColor: '#f3f3f3',
          mouseActiveRadius: 50
      },
      legend: {position: "sw"}
    };
  }

  function statGetMonth(m) {
    var months =  ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[m - 1];
  }

  function createTooltip(id) {
    $("<div>", {
      id: id
    }).css({
      position: "absolute",
      padding: "6px",
      background: "rgba(255,255,255,0.8)",
      border: "solid 2px rgba(230,230,230,0.8)",
      "font-size": "12px",
      "text-align": "center",
      display: "none",
      "z-index": 1000000
    }).appendTo("body");
  }

  function showTooltip(plot, tooltip) {
    plot.bind("plothover", function(e, pos, item) {
      if (item) {
        if ((prevLabel != item.series.label ) || (prevPoint != item.dataIndex)) {
          prevPoint = item.dataIndex;
          prevLabel = item.series.label;

          tooltip.hide();

          var date = new Date(item.datapoint[0]);

          tooltip.css({
            top: item.pageY - 30,
            left: item.pageX - 120
          }).show().html("<strong>" + statGetMonth(date.getMonth()) + " " + date.getDate() + "</strong><br /><span style='color:" + item.series.color + "'>" + item.datapoint[1] + " " + item.series.label + "</span>").fadeIn(200);
        }
      } else {
        tooltip.hide();
        prevPoint = null;
      }
    });
  }

  ["user", "note"].forEach(function(collection) {
    var statMsg = $("#stat-" + collection + "-msg");
    var msg;
    $.getJSON("/admin/stat/" + collection + ".json", function(data) {
      if (data.status === "ok") {
        msg = statGetMonth(data.data.month) + " " + data.data.year;
        if (collection === "user") {
          setupFlotUser(data.data);
        } else {
          setupFlotNote(data.data);
        }
      } else {
        msg = data.message;
      }
    }).fail(function() {
      msg = "Failed to fetch statistic.";
    }).always(function() {
      statMsg.text(msg);
    });
  });
});
