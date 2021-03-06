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
//= require jquery-ui
//= require_tree .

/* global $ */
/* global moment */
$(function () {
    // 「TOPに戻る」ボタンがクリックされた時の動きを指定します。
    $("#scroll_to_top").click(function() {
        // ページの一番上まで、アニメーション付きでスクロールさせます。
        // アニメーションの時間は300ミリ秒で、一定の速度（linear）で動かします。
        $('body, html').animate({scrollTop: 0}, 300, 'linear');
    });
    
    // 関数を変数「changeButtonState」に入れておきます。
    var changeButtonState = function() {
        // 「TOPに戻る」ボタンを取得します。
        var $toTopButton = $('#scroll_to_top');
    
        // 縦にどれだけスクロールしたかを取得します。
        var scrollTop = $(window).scrollTop();
    
        // ウィンドウの縦幅を取得します。
        var windowHeight = $(window).height();

        if (scrollTop >= windowHeight - 480
            || ($(document).height() - windowHeight) <= scrollTop) {
          // ウィンドウの縦幅以上にスクロールしていた、
          // またはページの下端に達していた場合、
          // 「TOPに戻る」ボタンを表示します。
          $toTopButton.show();
        } else {
          // ウィンドウの縦幅以上にスクロールしていない場合、
          // 「TOPに戻る」ボタンを隠します。
          $toTopButton.hide();
        }
    };

    // ウィンドウをスクロール・ロード・リサイズのイベント発火時に、
    // 「TOPに戻る】ボタンの表示・非表示を変更
    $(window).scroll(changeButtonState)
             .load(changeButtonState)
             .resize(changeButtonState);

    // #### ここからスケジュール(カレンダー)関係 ###
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
        // eventSources: [
        //     '/events.json',
        //     {url: 'http://www.google.com/calendar/feeds/ja.japanese%23holiday%40group.v.calendar.google.com/public/full/',
        //      color: 'red'
        //     }
        // ],
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
        //選択した日を色付け
        selectable: true,
        
        eventClick: function(item, jsEvent, view){
            var id = item.id;
            $.ajax({
            type: 'GET',
            url: '/events/' + id + '/edit'

          }).done(function (res) {
          }).fail(function (result) {
            // 失敗処理
            alert('エラーが発生しました。管理者に問い合わせてください。');
          });
        },
        
        eventMouseover: function(event, allDay, jsEvent){
            $(this).css('background-color', '#FF9933');
        },
        
        eventMouseout: function(event, allDay, jsEvent){
            $(this).css('background-color', '#63ceef');
        },
        
        dayClick: function (start, end, jsEvent, view) {
          //クリックした日付情報を取得
          var year = moment(start).year();
          var month = moment(start).month() + 1; //1月が0のため+1する
          var day = moment(start).date();
          //イベント登録のためnewアクションを発火
          $.ajax({
            type: 'GET',
            url: '/events/new',
            data: 'year_value=' + year + '&month_value=' + month + '&day_value=' + day
          }).done(function (res) {
            // alert(year + ' ' + month + ' ' + day);
            // alert(res);
            //イベント登録用のhtmlを作成
            // $('.modal-body').html(res);
            //イベント登録フォームの日付をクリックした日付とする
            // $('#event_start_time_1i').val(year);
            // $('#event_start_time_2i').val(month);
            // $('#event_start_time_3i').val(day);
            //イベント登録フォームのモーダル表示
            // $('#sampleModal').modal();
            // 成功処理
          }).fail(function (result) {
            // 失敗処理
            alert('エラーが発生しました。管理者に問い合わせてください。');
          });
        },
        // カレンダー高さ調整
        height: window.innerHeight - 100, 
        windowResize: function () {
            $('#calendar').fullCalendar('option', 'height', window.innerHeight - 100);
        },
    });
});