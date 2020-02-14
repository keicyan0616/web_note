// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require bootstrap
//= require bootstrap-sprockets
//= require jquery.turbolinks
//= require turbolinks
//= require moment
//= require moment/ja
//= require tempusdominus-bootstrap-4.js
//= require popper
//= require fullcalendar
//= require_tree .

/* global $ */
/* global moment */
$(function () {
    function eventCalendar() {
        return $('#calendar').fullCalendar({});
    }
    
    function clearCalendar() {
        $('#calendar').html('');
    }
    
    $(document).on('turbolinks:load', function () {
        eventCalendar();
    });
    
    $(document).on('turbolinks:before-cache', clearCalendar);

    $('#calendar').fullCalendar({
        events: '/events.json',
        //カレンダー上部を年月で表示させる
        titleFormat: 'YYYY年 M月',
        //曜日を日本語表示
        dayNamesShort: ['日', '月', '火', '水', '木', '金', '土'],
        //ボタンのレイアウト
        header: {
            left: '',
            center: 'title',
            right: 'today prev,next'
        },
        //終了時刻がないイベントの表示間隔
        defaultTimedEventDuration: '03:00:00',
        buttonText: {
            prev: '前',
            next: '次',
            prevYear: '前年',
            nextYear: '翌年',
            today: '今日',
            month: '月',
            week: '週',
            day: '日'
        },
        //イベントの時間表示を２４時間に
        timeFormat: "HH:mm",
        //イベントの色を変える
        eventColor: '#63ceef',
        //イベントの文字色を変える
        eventTextColor: '#000000',
        selectable: true,
        dayClick: function (start, end, jsEvent, view) {
          //クリックした日付情報を取得
          const year = moment(start).year();
          const month = moment(start).month()+1; //1月が0のため+1する
          const day = moment(start).date();
          //イベント登録のためnewアクションを発火
          $.ajax({
            type: 'GET',
            url: '/shops/events/new',
          }).done(function (res) {
            //イベント登録用のhtmlを作成
            $('.modal-body').html(res);
            //イベント登録フォームの日付をクリックした日付とする
            $('#event_start_time_1i').val(year);
            $('#event_start_time_2i').val(month);
            $('#event_start_time_3i').val(day);
            //イベント登録フォームのモーダル表示
            $('#modal').modal();
            // 成功処理
          }).fail(function (result) {
            // 失敗処理
            alert('エラーが発生しました。管理者(テスト)に問い合わせてください。')
          });
        },
    });
});