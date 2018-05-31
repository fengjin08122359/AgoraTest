<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
		<meta charset="utf-8">
		<meta name="renderer" content="ie-stand">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta>
		<title>云屋VideoCall测试</title>
		<meta http-equiv="X-UA-Compatible" content="IE=edge" ></meta>
		<meta name="viewport" content="width=device-width, initial-scale=1"></meta>
		<meta name="description" content="cloudroom live demo"></meta>
		<meta name="author" content="deva"/></meta>
		<meta http-equiv="Access-Control-Allow-Origin" content="*"></meta>
		<link rel="stylesheet" type="text/css" href="/webrtc/css/common.css">
		<link rel="stylesheet" type="text/css" href="/webrtc/css/index.css">
		<link rel="stylesheet" href="/webrtc/layui/css/layui.css">
		<script type="text/javascript" src="/webrtc/js/jquery-1.8.0.min.js"></script>
	</head>

	<body >
		<!--登录容器 -->	
		<div class="login_containt">
			<div class="login_module">
				<div class="login_header">
					<img src="/webrtc/image/icon_03.png">
				</div>
				<div class="login_header_name">
					<span>视频呼叫</span>
				</div>
				<div id="login_server" class="login_form_box" style="display:none">
					<div id="login_server_input" class="login_input">
						<label>服务器：</label>
						<input type="text" name="login_server" id="login_server_name" value="ali8.cloudroom.com">
						<!-- <span id="login_server_img"><img class="remeber_server" src="/webrtc/image/icon_14.png"></span> -->
						<div class="inputLayer1" id="login_server_player"></div>
						<script type="text/javascript">
							var localhref = window.location.host;
							$("#login_server_name").val(localhref)

						</script>
					</div>
				</div>
				
				<div id="login_cpyname" class="login_form_box">
					<div id="login_cpyname_input" class="login_input">
						<label>用户名：</label>
						<input type="text" name="login_cpyname_name" id="login_cpyname_name" value="demo@cloudroom.com" style="color: #222;">
						<div class="inputLayer3"></div>
						<script type="text/javascript">
							var localhref = window.location.host;
							$("#login_cpyname_name").val(sessionStorage.getItem("login_cpyname_name") || "demo@cloudroom.com");

						</script>
					</div>
				</div> 

				<div id="login_psd" class="login_form_box">
					<div id="login_psd_input" class="login_input">
						<label>密&nbsp;&nbsp;&nbsp;&nbsp;码：</label>
						<input type="password" name="login_psd_name" id="login_psd_name" value="123456" style="color: #222;">
						<div class="inputLayer4"></div>
					</div>
				</div>

				<div id="login_name" class="login_form_box">
					<div id="login_name_input" class="login_input">
						<label>登录昵称：</label>
						<input type="text" name="login_name" id="login_name_name" value="">
						<div class="inputLayer2" id="login_name_player"></div>
					</div>
				</div>
				<div id="login_style" class="login_form_box">
					<div id="login_style_input" class="login_input">
						<label>登录身份：</label>
						<input type="text" name="login_name" id="login_style_name" value="客户"  disabled="true" style="color: #222;">
						<span id="login_style_img"><img class="remeber_name" src="/webrtc/image/icon_14.png"></span>
					</div>
					<ul class="pull_down_name" id="login_style_pull">
						<li>客户</li>
						<li>坐席</li>
					</ul>
				</div>
				<div class="login_button">
					<button>登录</button>
				</div>
			</div>
		</div>
		
		<div class="queue_containt" style="display:none">
			<div class="queue_module">
				<!-- 头部开始 -->
				<div class="queue_header">
					<span class="queue_username">欢迎.....</span>
					<span class="queue_uptate" id="queue_uptate" onclick="refresh_que()">刷新</span>
					<span class="queue_logout" id="queue_logout" onclick="logout()">注销</span>
				</div>
				<!-- 头部结束 -->
				<!-- 列表开始 -->
				<ul id="queue_list">
				</ul>
				<!-- 列表结束 -->
			</div>
		</div>
		<div class="start_server_containt" style="display:none">
			<div class="start_server_module">
			    <div class="notifyUserBox" id="notifyUserBox">
					<div class="closeUserPage" onclick="closeUserPage()">X</div>
					<p></p>
				</div>
				<div class="notifyUserBox2" id="notifyUserBox2">
					<div class="closeUserPage" onclick="closeUserPage2()">X</div>
					<p></p>
				</div>
				<!-- 头部开始 -->
				<div class="start_server_header">
					<span class="start_server_username">欢迎<span id="start_server_username">ocean...</span></span>
					<span class="start_server_logout" id="start_server_logout" onclick="logout()">注销</span>
				</div>
				<!-- 头部结束 -->
				<!-- 列表开始 -->
				<ul id="start_server_list">
					<li>
						<span>窗口名称</span>
						<span>专家人数</span>
						<span>排队人数</span>
						<span>正在进行的对话</span>
						<span>服务状态</span>
						<span>优先级</span>
					</li>
				</ul>
				<div class="start_server_footer">
					<span class="start_server_footer_left">
						<input type="checkbox" name="start_server_disturb" id="start_server_disturb" value="0">
						<span>免打扰（手动分配）</span>
						<div style="display:inline-block;border:1px solid #ccc;margin-left: 10px;height: 30px;line-height: 30px;cursor: pointer;font-size: 12px;padding:4px;" onclick="startStatus()">开启用户状态监听</div>
						<div style="display:inline-block;border:1px solid #ccc;margin-left: 10px;height: 30px;line-height: 30px;cursor: pointer;font-size: 12px;padding:4px;" onclick="stopStatus()">停止用户状态监听</div>
					</span>
					<span class="start_server_footer_right">下一位客户</span>
				</div>
				<!-- 列表结束 -->
			</div>
		</div>
		<div class="meeting_containt" style="display:none">
			<div class="meeting_hdeader">
				<div class="meeting_header_main">
					<span class="meeting_header_main_left">
						<span class="meeting_hdeader_logo"><img src="/webrtc/image/icon_24.png" ></span>
						<span class="meeting_titile">您正在和【兔兔】视频会话中...</span>
					</span>
					
					<span class="meeting_head_wifi"><img src="/webrtc/image/icon_13.png"></span>
				</div>
			</div>
			<div class="meeting_media_box">
				<div class="meeting_media_title" style="display: block;">
					<div class="meeting_media_button_left">
						<!-- <span id="pic_btn"><img src="/webrtc/image/icon_30.png">截图</span>
						<span>查看截图</span> -->
					</div>
					<div class="meeting_media_button_right">
						<!-- <p class="radio_contain">
							<span class="radio_item">
								<input type="radio" name="time_range" checked="checked" value="1"/>
								<label class="radio_label ongray">
									<span class="radio_icon"></span>
									<span class="fs14_col48_verm_disib" style="color:#fff;">摄像头</span>
								</label>
							</span>
						</p> -->
            <span id="showRecordMsg" class="meet_start_record" style="width: 140px;"><img src="/webrtc/image/icon_38.png">开始录制</span>
						<span class="meet_start_file" style="display: inline-block;width: 40px;"><img src="/webrtc/image/icon_28.png"/></span>
					</div>
				</div>
				<!-- 视频区域 -->
				<div class="meet_video_media">
					<div class="meet_video_media_left">
						<div id="remoteName" class="videonickname"></div>
					</div>
					<div class="meet_video_media_right">
						<div class="meet_video_media_host">
							<div id="localName" class="videonickname"></div>
						</div>
						<div class="meet_video_media_reset">
							<div id="meet_reset_camera" class="meet_video_reset" style="margin-top: 12px;">
								<label class="meet_label">摄像头</label>
								<select id="video_select">
								</select>
								<button id="video_operate_btn">关闭</button>
							</div>
							<div id="meet_reset_speaker" class="meet_video_reset">
								<label class="meet_label">扬声器</label>
								<select id="spker_select">
								</select>
							</div>
							<div id="meet_reset_micraphone" class="meet_video_reset">
								<label class="meet_label">麦克风</label>
								<select id="mic_select">
								</select>
								<button id="mic_operate_btn">关闭</button>
							</div>
							<div id="meet_reset_video_size" class="meet_video_reset">
								<label class="meet_label">视频尺寸</label>
								<select id="size_select">
									<option value="1">144*80</option>
									<option value="2">224*128</option>
									<option value="3">288*160</option>
									<option value="4">336*192</option>
									<option value="5">448*256</option>
									<option value="6">512*288</option>
									<option value="7">576*320</option>
									<option value="8" selected="true">640*360</option>
									<option value="9">720*400</option>
									<option value="10">848*480</option>
									<option value="11">1024*576</option>
									<option value="12">1280*720</option>
									<option value="13">1920*1080</option>
								</select>
							</div>
							<div id="meet_reset_video_zl" class="meet_video_reset">
								<label class="meet_label">视频帧率</label>
								<input id="frame_input" type="text" name="meet_reset_video_zl" value="20">
							</div>
							<!-- <div id="meet_reset_video_yx" class="meet_video_reset">
								 <p class="radio_contain">
									<span class="radio_item">
										<input type="radio" name="meet_yx" checked="checked" value="0"/>
										<label class="radio_label ongray">
											<span class="radio_icon"></span>
											<span class="fs14_col48_verm_disib">视频质量优先</span>
										</label>
									</span>
								</p>
								 <p class="radio_contain">
									<span class="radio_item">
										<input type="radio" name="meet_yx" value="1"/>
										<label class="radio_label">
											<span class="radio_icon"></span>
											<span class="fs14_col48_verm_disib">视频流畅优先</span>
										</label>
									</span>
								</p>
							</div> -->
						</div>
					</div>
					<div style="clear: both;"></div>
					<div class="meet_audio_media" style="display: none;">
						<!-- <audio id="myAudio" autoplay="true"  controls width="70%" hight="30" style="display: block;float: left;"></audio> -->
						<!-- <audio id="mainAudio" autoplay="true"  controls width="30" hight="30" style="display: block;float: left;"></audio> -->
					</div>
				</div>
			</div>
			<div class="meet_send_file" style="display: none;">
				<!-- <div class="meet_sile_button">
					<button class="meet_send_button onsend">发送文本数据</button>
				</div> -->
				<div class="meet_send_text_button">
					<div class="meet_file_name_left">
						<textarea id="cmd_content"></textarea>
						<div class="meet_file_name_right">
							<button>发送文本</button>
						</div>
					</div>
				</div>
			</div>
			<div class="meet_close_window">
				<button id="meet_colse_btn">结束会话</button>
			</div>
		</div>
		<script type="text/javascript" src="/webrtc/js/md5.js"></script>
		<script type="text/javascript" src="/webrtc/js/index.js"></script>
		<script type="text/javascript" src="/webrtc/layui/layui.js"></script>
		<!-- <script type="text/javascript" src="/webrtc/js/bus2/zlib.min.js"></script> -->

  <!--  	<script type="text/javascript" src="/webrtc/js/bus2/adapter-latest.js"></script>
		<script type="text/javascript" src="/webrtc/js/bus2/rtc.js?v=3"></script>
	  <script type="text/javascript" src="/webrtc/js/bus2/postCmd.js?v=3"></script>
	  <script type="text/javascript" src="/webrtc/js/bus2/containerUI.js?v=3"></script>
	  <script type="text/javascript" src="/webrtc/js/bus2/enmeet.js?v=3"></script>
		<script type="text/javascript" src="/webrtc/js/bus2/sdkDebug.js?v=1"></script> -->
	    
	    <script type="text/javascript" src="/webrtc/js/rtcsdk.js?v=1"></script>

		<script type="text/javascript">
				//全局对象
				var g_is_init = false;//是否初始化
				var g_server_addr;//服务器地址
				var g_user_id;//用户id
				var g_nick_name;//昵称
				var g_login_type;//登录类型
				var g_meet_id;//会议id
				var g_meet_pwd;//会议密码
				var g_session_call_id;//会话id
				var g_call_user_id;//对方id
				var g_call_user_que;//呼叫的队列
				var g_me_user_id;//自己的id
				
				var g_loading_index = -1;
				var g_loading_deleted = false;
				
				var g_meeting = false;//会议进行中
				var g_bg_color = 0;
				var g_residual_timer = -1;
        //账号
        var cr_account = "";
        //密码
				var cr_psw = "";
        //目录地址


				var g_location_dir = function()
				{
					var location_dir = location.href
					var end = location_dir.lastIndexOf('/')
					var start = location_dir.indexOf('file:///')
					if(start > -1)
					{
						start = 8
					}else
					{
						start = 0;
					}
					location_dir = location_dir.slice(start,end)+"/home/"
					location_dir = decodeURIComponent(location_dir);
					return location_dir
				}()
				
				//弹出提示层
				function popupTipLayer(content)
				{
					console.log("g_meeting："+g_meeting)
					if(g_meeting)
					{
						$(".meeting_containt").css("display","none")
					}
					layui.use('layer', function(){ 
						var layer = layui.layer;
						layer.open({
						  title: ['提示', 'font-size:14px;'],
						  content:content, //这里content是一个普通的String
						  end:function()
						  {
							if(g_meeting)
							{
								$(".meeting_containt").css("display","block")
								// if(g_call_video !== undefined && g_me_video !== undefined)
								// {
								// 	g_call_video.setVideo(g_call_user_id);
								// 	g_me_video.setVideo(g_me_user_id);
								// }
	
							}

						  }
						});
					});
				}
				//删除加载层
				function removeLodingLayer()
				{
					if(g_loading_index != -1)
					{
						
						layui.use('layer', function()
						{ 
							var layer = layui.layer;
							layer.close(g_loading_index);
							g_loading_index = -1;
							g_loading_deleted = false;
						})
					}else
					{
						g_loading_deleted = true;
					}
				}
				//弹出加载层
				function popupLodingLayer()
				{
					if(g_meeting)
					{
						$(".meeting_containt").css("display","none")
					}
					layui.use('layer', function(){ 
						var layer = layui.layer;
						g_loading_deleted = false;
						g_loading_index = layer.load({end:function()
						  {
									if(g_meeting)
									{
										$(".meeting_containt").css("display","block")
										if(g_call_video !== undefined && g_me_video !== undefined)
										{
											g_call_video.setVideo(g_call_user_id);
											g_me_video.setVideo(g_me_user_id);
										}

									}
							}

						  });
						if(g_loading_deleted)
						{
							removeLodingLayer();
						}
					});
				}
				
	
				window.onbeforeunload = function()
				{
					CRVideo_Logout();
				    CRVideo_Uninit();
				}
				document.onkeydown = function (e) {
				    var ev = window.event || e;
				    var code = ev.keyCode || ev.which;
				    if (code == 116) {
				        if(ev.preventDefault) {
				            ev.preventDefault();
				            location.replace(location.href)
				        } else {
				            ev.keyCode = 0;
				            ev.returnValue = false;
				            location.replace(location.href)
				        }
				    }
				}
				// 屏蔽右键
				window.document.oncontextmenu = function(){ return false; };

				//注销
				function logout()
				{
					CRVideo_Logout();
					setTimeout(function()
					{	
						location.replace(location.href)
					},200)//延迟刷新页面防止logout未执行完毕
				}
				//刷新队列
				function refresh_que()
				{
					//CRVideo_RefreshAllQueueStatus();
					$("#queue_list li").remove();
					setTimeout(function(){
						CRVideo_InitQueueDat();
					},1000);
				}
				
				//离线
				CRVideo_LineOff.callback = function(sdkErr)
				{
					// console.log("CRVideo_LineOff(sdkErr:%s)",sdkErr);
					//if(sdkErr == CRVideo_CRVideoSDK_USER_BEEN_KICKOUT)	//会话掉线，重登
					//{
                        CRVideo.HandErrTimes =0;
						layer.open({
							type : 0, 
							area: '400px',
							title : ['提示', 'font-size:14px;'],
							content: "会话掉线", //注意，如果str是object，那么需要字符拼接。
							btn: ['确定'],
							yes: function(index, layero){
								location.replace(location.href);
								
							 }
						});

					//}
				}
				
				var updateDevices = function(){
					appendMicArr();
				    function appendMicArr(){
						var micArr = CRVideo_GetAudioMicNames();
						if(micArr.length < 1){
							setTimeout(function(){
								appendMicArr();
							},1000);
							return ;
						}
						console.log(micArr);
						$("#mic_select option").remove();
						var micArrOptionsStr = "";
						for(var i = 0;i<micArr.length;i++)
						{
							micArrOptionsStr += "<option value=\""+micArr[i].name+"\">"+micArr[i].name+"</option>"
						}
							$(micArrOptionsStr).appendTo("#mic_select");
					}
					appendSpkArr()
					function appendSpkArr(){
						var spkerArr = CRVideo_GetAudioSpkNames();
						if(spkerArr < 1){
							setTimeout(function(){
								appendSpkArr()
							},1000)
							return ;
						}
						console.log(spkerArr)
						$("#spker_select option").remove()
						var spkerArrOptionsStr = "";
						for(var i = 0;i<spkerArr.length;i++)
						{

							spkerArrOptionsStr += "<option value=\""+spkerArr[i].name+"\">"+spkerArr[i].name+"</option>"

						}
						$(spkerArrOptionsStr).appendTo("#spker_select")
					}
					appendVideoList();
					function appendVideoList(){
						var videoList = CRVideo_GetAllVideoInfo();
						if(videoList.length >0 && videoList[0].name !=''){
							$("#video_select option").remove();
							console.log(videoList)
							var videoListOptionsStr = "";
							for(var i = 0;i < videoList.length;i++)
							{
							var item = videoList[i];

								videoListOptionsStr += "<option value=\""+item.id+"\">"+item.name+"</option>"
							}
							$(videoListOptionsStr).appendTo("#video_select");
						}else {
							setTimeout(function(){
								appendVideoList();
							},1000);
						}
					}
				}
				//---------------------------------------------
				//
				//业务窗口
				//
				//---------------------------------------------
				
				var g_call_video;//呼叫的视频
				var g_me_video;//自己的视频
				var g_recording = false  // 是否已在录制中
        var g_record_timer = -1; // 录制按钮计时器
        var g_recDataType = 7; // 插件版有这个参数，录制视频的类型 初始值为音频+视频 纯音频为3

				var record_size_arr=[
         [0,0,0]
        ,[144,80,56]
				,[224,128,72]
				,[288,160,100]
				,[336,192,150]
				,[448,256,200]
				,[512,288,250]
				,[576,320,300]
				,[640,360,350]
				,[720,400,420]
				,[848,480,500]
				,[1024,576,650]
				,[1280,720,1000]  // 云端录制默认尺寸
        ,[1920,1080,2000]]
        
        
				updateRecord = function(isOneSvr){
          if(g_recording){
            var videoAContent = {},
                videoAStampContent = {},
                videoBContent = {},
                videoBStampContent = {};

            var recContents = [];
            
						var size = record_size_arr[12]
						var w = size[0]
						var h = size[1]
						if(g_call_user_id !== undefined){

							videoAContent["type"] = 0; // 录视频
							videoAContent["left"] = 0;
              videoAContent["top"] = h / 4;
							videoAContent["width"] = w / 2;
              videoAContent["height"] = h / 2;
							videoAContent["param"] = {"camid":g_call_user_id+"."+CRVideo_GetDefaultVideo(g_call_user_id)};
              videoAContent["keepAspectRatio"] = 1;
							recContents.push(videoAContent);
            }
            
            videoAStampContent["type"] = 4; // 加时间戳
            videoAStampContent["left"] = videoAContent["left"]+35;
            videoAStampContent["top"] = videoAContent["top"]+3;
            videoAStampContent["width"] = 175;
            videoAStampContent["height"] = 32;
            videoAStampContent["keepAspectRatio"] = 1;
            recContents.push(videoAStampContent);
						
						if(g_me_user_id !== undefined){
              
              videoBContent["type"] = 0; // 录制视频
							videoBContent["left"] = w/2;
							videoBContent["top"] = h/4;
							videoBContent["width"] = w/2;
							videoBContent["height"] = h/2;
							videoBContent["param"] = {"camid":g_me_user_id+"."+CRVideo_GetDefaultVideo(g_me_user_id)};
							videoBContent["keepAspectRatio"] = 1;
							recContents.push(videoBContent);
            }

            videoBStampContent["type"] = 4; // 时间戳
            videoBStampContent["left"] = videoBContent["left"]+35;
            videoBStampContent["top"] = videoBContent["top"]+3;
            videoBStampContent["width"] = 175;
            videoBStampContent["height"] = 32;
            videoBStampContent["keepAspectRatio"] = 1;
            recContents.push(videoBStampContent);

						if(isOneSvr){
							return recContents ;
						}else{
							CRVideo_UpdateSvrRecordContents(recContents);
						}
            //CRVideo_SetRecordVideos(recContents);
          }
        }

				$("#meet_colse_btn").click(function()
				{
					CRVideo_HungupCall(g_session_call_id);
					$(".meeting_containt").hide();
					if(g_login_type == 1) //客户
					{
						$('.queue_containt').show();;
					}
					else if(g_login_type == 2)	//坐席
					{	
						$('.start_server_containt').show();
					}
				})
				$("#video_operate_btn").click(function()
				{
					var vStatus = CRVideo_GetVideoStatus(g_me_user_id);
					if(vStatus == 0)
					{
						alert("没有可打开的视频设备")

					}
					else if(vStatus ==  2)
					{
						CRVideo_OpenVideo(g_me_user_id);
						$("#video_operate_btn").text("关闭");
					}
					else 
					{
						CRVideo_CloseVideo(g_me_user_id);
						$("#video_operate_btn").text("打开");

					}
				})

				$("#mic_operate_btn").click(function()
				{
					var aStatus = CRVideo_GetAudioStatus(g_me_user_id);
					if(aStatus == 0)
					{
						alert("没有可打开的音频设备")


					}
					else if(aStatus ==  2)
					{
						CRVideo_OpenMic(g_me_user_id);
						$("#mic_operate_btn").text("关闭");
					}
					else 
					{
						CRVideo_CloseMic(g_me_user_id);
						$("#mic_operate_btn").text("打开");

					}
        })
        
				$("#showRecordMsg").click(function(){
					if(!g_recording){
						
						var date = new Date();
						var year = date.getFullYear();
						var month = date.getMonth() + 1;
						var day = date.getDate();
						var hour = date.getHours();
						var minute = date.getMinutes();
            var second = date.getSeconds();

            month = month < 10 ? ('0' + month) : month;
            day  = day  < 10 ? ('0' + day ) : day ;
            hour = hour < 10 ? ('0' + hour) : hour;
            minute = minute < 10 ? ('0' + minute) : minute;
            second = second < 10 ? ('0' + second) : second;

            var recordName = year + "-" + month + "-" + day + "-" + hour + '-' + minute + '-' + second + ".mp4";
						var size = record_size_arr[12];
						var frame = 15;
            // var zhilaing = 26;
            
						var svr_recordCfgObj =	{
              "filePathName": recordName,
              "recordWidth": size[0] ,
              "recordHeight": size[1],
              "frameRate": frame,
              "bitRate": size[2]*1000,
              "defaultQP": 22,
              "recDataType": g_recDataType || 3,
              "serverPathFileName":'/webrtc_svrrecord/' + year + month + day + '/' + recordName
            };

            g_recording = true;
            var svr_recordContentObj = updateRecord(true);
            CRVideo_StartSvrRecording(svr_recordCfgObj, svr_recordContentObj);
            
						//CRVideo_StartRecordIng(g_location_dir+"record/"+recordName,CRVideo_RECORD_AUDIO_TYPE.REC_AUDIO_TYPE_ALL,frame,size[0],size[1],size[2]*1000,zhilaing,7);
						
						$("#showRecordMsg").html("<img src=\"/webrtc/image/icon_38.png\"/>停止录制");
						$("#showRecordMsg").text("停止(00:00 0M)")
						if(g_record_timer != -1){
							clearInterval(g_record_timer);
						}
						var nowTime = 0;
						g_record_timer = setInterval(function(){
							nowTime++;
							var second = nowTime%60;
							var second_str = second >= 10? second.toString():"0"+second;
							var minute = parseInt(nowTime/60);
							var minute_str = minute >= 10? minute.toString():"0"+minute;
							$("#showRecordMsg").text("停止("+minute_str+":"+second_str+")");
            },1000)
            
  
					} else if(g_recording){
            
						CRVideo_StopRecord();
						$("#showRecordMsg").html("<img src=\"/webrtc/image/icon_38.png\"/>开始录制");
						g_recording = false;
						
						if(g_record_timer != -1)
						{
							clearInterval(g_record_timer);
							g_record_timer = -1
						}
					}
        })
        

				$("#pic_btn").click(function()
				{

					if(g_call_video.isPicEmpty() == 0)
					{
						var date = new Date();
						var year = date.getFullYear();
						var month = date.getMonth()+1;
						var day = date.getDate();
						var hour = date.getHours();
						var minute = date.getMinutes();
						var second = date.getSeconds();
						var picName = year + "-" + month + "-" + day + "-" + hour+'-' + minute + '-' + second+".png"

						g_call_video.savePic(g_location_dir+"img/"+picName)

						popupTipLayer("截图位置("+g_location_dir+"img/"+picName+")");

					}else
					{

						popupTipLayer("没有图像");
					}
				})
				$(".meet_file_name_right").click(function()
				{
					if($("#cmd_content").val() == ""){
						return;
					}
					CRVideo_SendCmd(g_call_user_id,$("#cmd_content").val());
				})
				
				$("#video_select").change(function()
				{
					CRVideo_SetDefaultVideo(g_me_user_id,$("#video_select").val());
				});
				$("#spker_select").change(function()
				{
					var cfg = {};
					cfg.micName = $("#mic_select").val();
					cfg.speakerName = $("#spker_select").val();
					cfg.privAgc = 0;
					cfg.privEC = 0;
					CRVideo_SetAudioCfg(cfg);
				});
				$("#mic_select").change(function()
				{
					var cfg = {};
					cfg.micName = $("#mic_select").val();
					cfg.speakerName = $("#spker_select").val();
					cfg.privAgc = 0;
					cfg.privEC = 0;
					CRVideo_SetAudioCfg(cfg);
				});
				function updateVideoCfg()
				{
					var cfg = {}

					var sizeType = parseInt($("#size_select").val())
					cfg.sizeType = sizeType
					
					var fps = parseInt($("#frame_input").val())
					if(fps < 5)
					{
						fps = 5
					}else if(fps > 20)
					{
						fps = 20
					}
					cfg.fps = fps
					
					
					cfg.maxbps = record_size_arr[sizeType][2];
					
					var qp = $("input[name='meet_yx']:checked").val();
					if(qp == 0)
					{
						cfg.qp_min = 22
						cfg.qp_max = 25
					}else if(qp == 1)
					{
						cfg.qp_min = 22
						cfg.qp_max = 36
					}
					CRVideo_SetVideoCfg(cfg)
				}
				$("#size_select").change(function(){
				  updateVideoCfg();
				});
				$("#frame_input").change(function(){
				  updateVideoCfg();
				});
				//进入会议结果
				CRVideo_EnterMeetingRslt.callback = function(sdkErr)
				{
					// console.log("CRVideo_EnterMeetingRslt(sdkErr:%s)",sdkErr);
					console.log("CRVideo_EnterMeetingRslt："+CRVideo.meetingInfo);
					removeLodingLayer();
					if(sdkErr == 0)
					{
						$('.start_server_containt').css('display',"none");
						$('.queue_containt').css('display',"none");
						$(".meeting_containt").css("display","block")
						g_meeting = true;

						
						g_call_video = CRVideo_CreatVideoObj();
						g_call_video.width(800);
						g_call_video.height(450);
						$(".meet_video_media_left").append(g_call_video.handler());
						

					
						g_me_video = CRVideo_CreatVideoObj();
						g_me_video.width(400)
						g_me_video.height(225)
						$(".meet_video_media_host").append(g_me_video.handler());

						setTimeout(function(){
							g_call_video.keepAspectRatio(1);
							g_me_video.keepAspectRatio(1);
						},500)
						
						//打开麦克风
						CRVideo_OpenMic(g_me_user_id);
						$("#mic_operate_btn").text("关闭");

						//打开视频
						CRVideo_OpenVideo(g_me_user_id);
						$("#video_operate_btn").text("关闭");

						//updateVideoCfg();

						//设置自己视频,延迟显示(ie8有可能组件还没初始化完毕)
						setTimeout(function()
						{
							g_me_video.setVideo(g_me_user_id)
						},500);
						
						//设置对方的视频,延迟显示(ie8有可能组件还没初始化完毕)
						$(".meeting_titile").text("您正在和【"+g_call_user_id+"】视频会话中...");
						setTimeout(function()
						{
							g_call_video.setVideo(g_call_user_id)
						},500);
						setTimeout(function(){
							updateDevices();
						},500);
						
					}else
					{

						$(".meeting_containt").css("display","none");
						g_meeting = false
						g_user_srv_layer_index = layer.open({
							type : 0, 
							area: '400px',
							title : ['提示', 'font-size:14px;'],
							content: '进入会议失败,是否重连', //注意，如果str是object，那么需要字符拼接。
							btn: ['<p style="font-size:14px;">确定</p>','<p style="font-size:14px;">取消</p>'],
							yes: function(index, layero){
								layer.close(index)
								CRVideo_EnterMeeting(g_meet_id,g_meet_pwd,g_user_id,g_nick_name);
								popupLodingLayer();

							}.bind(this),
							btn2: function(index, layero){
								layer.close(index);
								logout();
							 }.bind(this),
						});
					}
					
				}
				//会议掉线
				CRVideo_MeetingDropped.callback = function()
				{
					CRVideo_EnterMeeting(g_meet_id,g_meet_pwd,g_user_id,g_nick_name);

					$(".meeting_containt").css("display","none");
					g_meeting = false
					popupLodingLayer();
				}
				//用户进入会议
				CRVideo_UserEnterMeeting.callback = function(args)
				{
					console.log("CRVideo_UserEnterMeeting(usrID:%%%%%)："+args);
				}
				CRVideo_UserLeftMeeting.callback = function(id)
				{
					console.log("CRVideo_UserLeftMeeting："+id)
					// console.log("CRVideo_UserEnterMeeting(usrID:%s)",usrID);
					if(g_user_id == id){
						//如果是自己退出
						CRVideo_ExitMeeting();
						g_session_call_id = null;
						if(g_record_timer != -1)
						{
							clearInterval(g_record_timer);
							g_record_timer = -1
						}
						$(".meeting_containt").css("display","none")
						g_meeting = false
						if(g_call_video !== undefined && g_me_video !== undefined )
						{
							//g_call_video.clear();
							//g_me_video.clear();
						}
						if(g_login_type == 1) //客户
						{
							$('.queue_containt').css('display',"block");
						}
						else if(g_login_type == 2)	//坐席
						{	
							$('.start_server_containt').css('display',"block");
						}
					}else{
						//如果不是自己离开会议
						//popupTipLayer("用户"+id+"离开了会议");
						console.log("用户"+id+"离开了会议")
					}
				}
				CRVideo_NotifyCmdData.callback = function(sourceUserId,data)
				{
					popupTipLayer("收到"+sourceUserId+"的消息："+data);
				}
				//挂断呼叫操作成功响应
				CRVideo_HangupCallSuccess.callback = function(callID,cookie)
				{
					// console.log("CRVideo_HangupCallSuccess(callID:%s)",callID);
					CRVideo_ExitMeeting();
					//g_session_call_id = null;
					if(g_record_timer != -1)
					{
						clearInterval(g_record_timer);
						g_record_timer = -1
					}
					$(".meeting_containt").css("display","none")
					g_meeting = false
					if(g_call_video !== undefined && g_me_video !== undefined )
					{
						g_call_video.clear();
						g_me_video.clear();
					}
					if(g_login_type == 1) //客户
					{
						$('.queue_containt').css('display',"block");
					}
					else if(g_login_type == 2)	//坐席
					{	
						$('.start_server_containt').css('display',"block");
					}
				}
				//挂断呼叫操作失败响应
				CRVideo_HangupCallFail.callback = function(callID,sdkErr,cookie)
				{
					// console.log("CRVideo_HangupCallFail(callID:%s,sdkErr:%s)",callID,sdkErr);
					removeLodingLayer()
					popupTipLayer("挂断呼叫失败！");
					
				}
				//SDK通知自己呼叫被挂断
				CRVideo_NotifyCallHungup.callback = function(callID,usrExtDat)
				{
					// console.log("CRVideo_NotifyCallHungup(callID:%s)",callID);
					CRVideo_ExitMeeting();
					g_session_call_id = null;
					if(g_record_timer != -1)
					{
						clearInterval(g_record_timer);
						g_record_timer = -1
					}
					$(".meeting_containt").css("display","none")
					g_meeting = false
					$("video").remove();
					
					if(g_login_type == 1) //客户
					{
						$('.queue_containt').css('display',"block");
					}
					else if(g_login_type == 2)	//坐席
					{	
						$('.start_server_containt').css('display',"block");
					}
					popupTipLayer("对方挂断了呼叫");
				}
				CRVideo_VideoStatusChanged.callback = function(userID,oldStatus,newStatus)
				{
					
					// console.log("CRVideo_VideoStatusChanged(userID:%s,oldStatus:%s,newStatus:%s)",userID,oldStatus,newStatus);
					updateRecord();
				};
				CRVideo_DefVideoChanged.callback = function(userID,videoID)
				{
					
					// console.log("CRVideo_DefVideoChanged(userID:%s,videoID:%s)",userID,videoID);
					updateRecord();
				};
				CRVideo_VideoDevChanged.callback = function(userID)
				{
					
					// console.log("CRVideo_VideoDevChanged()");
					setTimeout(function()
					{
						updateRecord()
					},50);
				};
				//------------------------------
				//
				//队列
				//
				//------------------------------
				
	
				var g_que_dict;//列队数据
				var g_queuing_info;//排队信息
				var g_user_srv_layer_index = -1;//服务用户层索引
				var g_user_que_layer_index = -1;//服务用户层索引
				//查询列队是否在服务中
				
				function getServicedById(queID)
			    {   
			       var result = CRVideo.queServiceInfo.indexOf(","+queID+"-queID");
				 
				   return CRVideo.queServiceInfo.indexOf(","+queID+"-queID") != -1;
			    }
			     /*
				function getServicedById(queID)
				{
					var servingQues = CRVideo_GetServingQueues();
					var servingQues_length = servingQues.length;
					for(var i = 0;i < servingQues_length;i++)
					{
						var item = servingQues[i];
						if(item == queID)
						{
							return true;
						}
					}
					return false;
				}
				*/
				//设置列队是否免打扰
				function setSrvDNDState(state)
				{
					if(state)
					{
						$(".start_server_footer_right").css("display","inline")
						CRVideo_SetDNDStatus(1);
						 
					}
					else 
					{

						$(".start_server_footer_right").css("display","none")
						CRVideo_SetDNDStatus(0);//0:代表关闭免打扰， 其它值代表开启免打扰
						 
					}
				}
				CRVideo_NotifyUserStatus.callback = function(userStatus,cookie){
				
				}
				CRVideo_SetDNDStatusSuccess.callback= function(json){
		             
	        
			        console.log("CRVideo_SetDNDStatusSuccess back ClientCustomStatusUpdate end " +JSON.stringify(json));
                };
				
			    CRVideo_SetDNDStatusFail.callback= function(json){
		             
			        console.log("SetDNDStatusFailCallBack ClientCustomStatusUpdate end " +JSON.stringify(json));
                };
				//更新队列状态
				function updateQue(status)
				{
					for (var name in g_que_dict)
					{
						var item = g_que_dict[name];
						if(item["queId"] == status.queID)
						{
							if(g_login_type == 2)
							{
								item["expertNum_span"].text(status.agent_num);
								item["queNum_span"].text(status.wait_num);
								item["srvNum_span"].text(status.srv_num);
							
							}else
							{
								item["queNum_span"].text(status.wait_num + "人");
							}
							break;
						}
						
					}
				}
				//删除请求服务用户层
				function removeUserSrvLayer()
				{
					if(g_user_srv_layer_index != -1)
					{
						layui.use('layer', function()
						{ 
							var layer = layui.layer;
							layer.close(g_user_srv_layer_index);
							g_user_srv_layer_index = -1;
						})
					}
				}
				//弹出请求服务用户层
				function popupUserSrvLayer(user)
				{
					 
					layui.use('layer', function()
					{ 
						var layer = layui.layer;
						if(g_user_srv_layer_index != -1)
						{
							layer.close(g_user_srv_layer_index);
						}
					
						g_user_srv_layer_index = layer.open({
							type : 0, 
							area: '400px',
							title : ['用户分配中', 'font-size:14px;'],
							content: '系统为您分配【'+user.userID+'】', //注意，如果str是object，那么需要字符拼接。
							btn: ['<p style="font-size:14px;">确定</p>','<p style="font-size:14px;">取消</p>'],
							yes: function(index, layero){
									layer.close(index);
									g_call_user_id = user.userID;
									g_call_user_que = user.queID;
									//CRVideo_CreateMeeting("test")
									CRVideo_CreateMeeting(g_server_addr,cr_account,cr_psw,"testqq");
									g_user_srv_layer_index = -1;
									popupLodingLayer();
							}.bind(this),
							btn2: function(index, layero){
								layer.close(index);
								CRVideo_RejectAssignUser(user.queID, user.userID);
								g_user_srv_layer_index = -1;
							 }.bind(this),
						});
						layer.config({
						  skin: 'demo-class',

						});	
						
					});
				}
				//删除请求用户排队层
		function removeUserQueLayer()
				{
					if(g_user_que_layer_index != -1)
					{
						layui.use('layer', function()
						{ 
							var layer = layui.layer;
							layer.close(g_user_que_layer_index);
							g_user_que_layer_index = -1;
						})
					}
				}
				//弹出请求用户排队层
		 function popupUserQueLayer(user)
				{
					layui.use('layer', function()
					{ 
						var layer = layui.layer;
						var content;
						var timer;
						var s = 0;
						if(g_user_que_layer_index != -1)
						{
							layer.close(g_user_que_layer_index);
						}
					
						g_user_que_layer_index = layer.open({
							type : 0, 
							area: '400px',
							title : ['用户分配中', 'font-size:14px;'],
							content: "你已经排队等待0秒", //注意，如果str是object，那么需要字符拼接。
							btn: ['<p style="font-size:14px;">取消</p>'],
							yes: function(index, layero){
								CRVideo_StopQueuing();
								layer.close(index);
								g_user_que_layer_index = -1;
								
							 },
						 end:function()
						 {
							clearInterval(timer)
						 },
						   success: function(layero, index){
								timer = setInterval(function()
								{
									if(g_queuing_info !== undefined)
									{
										s++;
										 $(layero).find('.layui-layer-content').html("你已经排队等待"+ s+"秒");
									}
									
								},1000)
							}
						});
						layer.config({
						  skin: 'demo-class',

						});	
						
					});
		}
		               
		CRVideo_StartUserStatusNotifyRslt.callback = function(sdkErr,cookie){
				if(sdkErr == 0){
					var msg = "您已开启在线用户信息";
					$("#notifyUserBox p").text(msg)
					$("#notifyUserBox").show();
				}
		}
		CRVideo_StopUserStatusNotifyRslt.callback = function(sdkErr,cookie){
				if(sdkErr == 0){
					var msg = "您已关闭在线用户信息";
					$("#notifyUserBox p").text(msg)
					$("#notifyUserBox").show();
				}
		 }
		 // 获取用户状态信息失败
		CRVideo_GetUserStatusSuccess.callback = function(usersStatus,cookie){
				// var msg = "目前有" + usersStatus.length +"用户在线";
				// $("#notifyUserBox p").text(msg)
				// $("#notifyUserBox").show();

			}
		CRVideo_GetUserStatusFail.callback = function(sdkErr,cookie){

				var msg = "获取在线用户信息失败,错误码：" + sdkErr;
				$("#notifyUserBox p").text(msg)
				$("#notifyUserBox").show();
			}
		function closeUserPage(){
				$("#notifyUserBox").hide();
			}
		function closeUserPage2(){
				$("#notifyUserBox2").hide();
		}
		function startStatus(){
				CRVideo_StartUserStatusNotify();
		}
			
		 function stopStatus(){
				CRVideo_StopUserStatusNotify();
		 }
		 
		  
		//获取业务数据  GetServiceDataRslt
         CRVideo_InitQueueDatRslt.callback= function(RspCode,cookie){
		      console.log("GetServiceDataRslt InitQueueDatRsltCallBack ");
		      
			  if(RspCode == 0){
			    /*
			   if(seeisoninfo.callID != "" && seeisoninfo.duration > 0)
					{
						layui.use('layer', function(){ 
							var layer = layui.layer;
							layer.open({
								area: '500px',
								title : ['提示', 'font-size:14px;'],
								closeBtn: 0,
								content: '是否恢复意外关闭的视频会话', //注意，如果str是object，那么需要字符拼接。
								btn: ['<p style="font-size:14px;">确定</p>','<p style="font-size:14px;">取消</p>'],
								yes: function(index, layero){
									layer.close(index)
									g_meet_id = seeisoninfo.meetingID;
									g_meet_pwd = seeisoninfo.meetingPswd;
									g_session_call_id = seeisoninfo.callID;
									g_call_user_id = seeisoninfo.peerName;
									g_seat_id = g_user_id;
									//if(g_is_third_or_seat == "1"){
										CRVideo_EnterMeeting(g_meet_id,g_meet_pwd,g_seat_id,g_seat_id);
										g_is_third_or_seat == "1";

									//}else{
										//CRVideo_EnterMeeting(g_meet_id,g_meet_pwd,g_user_id,g_user_id);
									//}
									
									popupLodingLayer()
								},
								btn2: function(index, layero){
									layer.close(index);
									if(g_is_third_or_seat == "1"){
										CRVideo_HungupCall(seeisoninfo.callID);
										$("#chatsList div").remove();
									}else{
										CRVideo_HungupCall(seeisoninfo.callID);
										$("#chatsList div").remove();
									}
									

								},
							});
							
						});
					}
					*/
					/*
					 {"ques": [{"desc": "", "queID": 96, "prio": 10, "name": ""}, 
					           {"desc": "", "queID": 98, "prio": 10, "name": ""}, {"desc": "", "queID": 100, "prio": 10, "name": ""},
					           {"desc": "", "queID": 78, "prio": 10, "name": ""}, 
					           {"desc": "11111", "queID": 79, "prio": 9, "name": ""}],
					 "RspCode": 0, "RspDesc": "Ok"}
					*/
					var que_info =CRVideo_GetAllQueueInfo();
					var queInfos_length = que_info.length;
					console.log("queInfos_length "+ queInfos_length);
					CRVideo_RefreshAllQueueStatus(); // 之前 demo 封装 到 refresh_que 为啥 ？
					//初始化坐席业务列表
					g_que_dict = {};
					
					$('.start_server_list_li').remove();
					$(".start_server_open_server").text("请开启服务");

					 
					 
					for(var i = 0;i < queInfos_length;i++)
					{
						var item = que_info[i];
						/*
						//var status = CRVideo.GetQueueStatusRslt;
						 var queStatusInfos = CRVideo.queStatusInfo;
						 alert("queStatusInfos=" +CRVideo.queStatusInfo)
						//console.log("status=" +status);
						 for(var k=0;k< queStatusInfos.length;k++){
                                var quetmp=CRVideo.queStatusInfo[k];
                                 if (quetmp.queID==obj.queID) {
								     var status	 = quetmp;
									 
						     }		
                         }
						 */
						 if(g_login_type == 2) {
						     
							var li = $("<li class='start_server_list_li'/>")

							var name_span = $("<span>"+item.name+"</span>")
							li.append(name_span);
							
							var expertNum_span = $('<span id="span_en_'+item.queID+'"  >'+0+'</span>');
							li.append(expertNum_span);
							
							var queNum_span = $('<span id="span_qn_'+item.queID+'"  >'+0+'</span>');
							li.append(queNum_span);
							
							var srvNum_span = $('<span id="span_sn_'+item.queID+'"  >'+0+'</span>');
							li.append(srvNum_span);
							
							var srvStatus_span = $("<span/>")
							var btn = $("<span id=\"srv_open_btn_"+item.queID+"\" class=\"start_server_open_server\">请开启服务</span>")
							 
							if(getServicedById(item.queID))
							{
								btn.text("服务中...");
								btn.addClass("active");
								
							}else
							{
								btn.text("请开启服务");
								btn.removeClass("active");
							}
							 
							srvStatus_span.append(btn);
							li.append(srvStatus_span);
							
							var priority_span = $("<span>"+item.prio+"</span>")
							li.append(priority_span);
							
							
							g_que_dict[btn.attr("id")] = {"queId":item.queID,"expertNum_span":expertNum_span,"queNum_span":queNum_span,"srvNum_span":srvNum_span,"srvStatus_span":srvStatus_span};
							
							$('#start_server_list').append(li) ;
							btn.click(function(e)
							{
								queData = g_que_dict[$(this).attr("id")];
								var queID = queData["queId"];
							 	if(getServicedById(queID))
								 {
									CRVideo_StopService(queID);
									 
									$(this).text("请开启服务");
									$(this).removeClass("active");
								 }
								 
								else 
								{
								   CRVideo_StartService(queID);
									$(this).text("服务中...");
									$(this).addClass("active");
								}
								 
							});
						    
						} else {
						     
							//var status = CRVideo_GetQueueStatus(item.queID);
							var li = $('<li id="queue_li_'+item.queID+'" class="clearfix"></li>');
							var name_span = $('<span class="queue_list_left">'
											+		'<span>'+item.name+'</span>'
											+		'<span>'+item.desc+'</span>'
											+	'</span>');
							li.append(name_span);
							var queNum_span = $('<span id="span_li_'+item.queID+'" class="queue_list_right">'+0+' 人</span>');
							li.append(queNum_span);
							g_que_dict[li.attr("id")] = {"queId":item.queID,"name_span":name_span,"queNum_span":queNum_span};
							$("#queue_list").append(li);
							li.click(function() {
								queData = g_que_dict[$(this).attr("id")];
								var queID = queData["queId"];
								
								CRVideo_StartQueuing(queID);
								 
							});
							 
						}	
						 
					}
					 
					if(g_login_type == 2) {
					     
						setSrvDNDState(0);
						CRVideo_GetUserStatus();
						
						$(".start_server_footer_right").click(function(e)
						{
							CRVideo_ReqAssignUser();
						})
						
						$("#start_server_disturb").click(function(e)
						{
							var checkVal = $("input[type='checkbox']").is(':checked');
							setSrvDNDState(checkVal)
						})
					}
					 
			  }
			  else {
			     removeLodingLayer();
		         //popupTipLayer('获取队列失败:');
			     alert('获取队列失败');
		         $('.login_containt').css('display',"block");
			  }
	       
         };	
	        
				//开始排队响应
				CRVideo_StartQueuingRslt.callback = function(json ,errCode,cookie)
				{
					// console.log("CRVideo_StartQueuingRslt(sdkErr%s)",errCode);
					
					if(errCode == 0)
					{
						console.log("排队成功 ........" ); 
						CRVideo_GetQueueStatus(CRVideo.queuingID);
				        CRVideo_QueuingInfoChanged.callback(json);
				        //排队成功 返回 IcePH5.{"position": 2, "RspCode": 0, "RspDesc": "Ok"}  CRVideo_QueuingInfoChanged.callback
				 
		                popupUserQueLayer();

					}
					 else {
			             console.log("排队失败........" );
				         removeUserQueLayer();
			           //排队失败；
			        }
				}
				//停止排队响应
				CRVideo_StopQueuingRslt.callback = function(errCode,cookie)
				{
					// console.log("CRVideo_StopQueuingRslt(sdkErr%s)",errCode);

				}
				//
				CRVideo_NotifyCallIn.callback = function(callID ,meetObj,callerID,usrExtDat)
				{
					// console.log("CRVideo_NotifyCallIn(callID%s,callerID%s,usrExtDat%s)",callID ,callerID,usrExtDat);
					removeUserQueLayer();
					CRVideo_AcceptCall(callID,meetObj)
					console.log("CRVideo_AcceptCall" );
					g_meet_id = meetObj.ID;
					g_meet_pwd = meetObj.pswd;
					g_session_call_id = callID;
					g_call_user_id = callerID;
					popupLodingLayer()
					CRVideo_EnterMeeting(meetObj.ID,meetObj.pswd,g_user_id,g_nick_name);
					console.log("CRVideo_EnterMeeting" );
				}
				CRVideo_GetQueueStatusRslt.callback= function(json){
				
		        //console.log("GetQueueStatusRsltCalBack  =" +JSON.stringify(json));
		        if(json.RspCode == 0){
		                 var obj =eval(json.status) ;
			            //console.log("GetQueueStatusRslt obj.queID =" +obj.queID);
				
                        if(g_login_type == 2) {
				
				        }
                        else {
				    
				          var spanid = "span_li_"  +obj.queID;
				    
                           //console.log("start spanid =" +spanid + obj.wait_num);
				           $("#"+spanid).html(obj.wait_num +" 人");
					     //console.log("end spanid =" +spanid);
				        }  	
		           }
		           else {
		           }
		  				 
               
                };	
		  
				//正在排队信息更新
				CRVideo_QueuingInfoChanged.callback = function(queuingInfo)
				{
					// console.log("CRVideo_QueuingInfoChanged(queuingInfo%s)",queuingInfo);
					g_queuing_info = queuingInfo;
				}

				//列队状态改变
				CRVideo_QueueStatusChanged.callback = function(queStatus)
				{
					updateQue(queStatus);
				}

				//开启队列服务响应
				CRVideo_StartServiceRslt.callback = function(queID,sdkErr,cookie)
				{
					// console.log("CRVideo_StartServiceRslt(queID:%s,sdkErr:%s)",queID,sdkErr);
					if(sdkErr == CRVideo_NOERR)	//开始服务队列，更新该队列的状态信息
					{
						var status = CRVideo_GetQueueStatus(queID);
						// console.log("que status(agent_num:%s,wait_num:%s,srv_num:%s)",status.agent_num,status.wait_num,status.srv_num);
						updateQue(status);
					}	
				}
				//停止队列服务响应
				CRVideo_StopServiceRslt.callback = function(queID,sdkErr,cookie)
				{
					// console.log("CRVideo_StopServiceRslt(queID:%s,sdkErr:%s)",queID,sdkErr);

					//停止服务，清空队列信息
					/*for (var name in g_que_dict)
					{
						var item = g_que_dict[name];
						if(item["queId"] == queID)
						{
							item["expertNum_td"].innerHTML = 0;
							item["queNum_td"].innerHTML = 0;
							item["srvNum_td"].innerHTML = 0;
							break;
						}	
					}*/
				}

				//系统自动安排客户	
				CRVideo_AutoAssignUser.callback = function(usr)
				{
					 console.log("CRVideo_AutoAssignUser(usrID:%s)："+usr.usrID);
					popupUserSrvLayer(usr);
				}
				//请求分配客户操作结果
				CRVideo_ReqAssignUserRslt.callback = function(errCode,usr,cookie )
				{
					// console.log("CRVideo_ReqAssignUserRslt(errCode:%s)",errCode);
					if(errCode == 0)
					{
						popupUserSrvLayer(usr);
					}else if(errCode == 101)
					{
						popupTipLayer("目前没有需要服务的客户")
					}else if(errCode == 103)
					{
						popupTipLayer("未开启队列服务")
					}
				}
				//系统取消自动安排客户
				CRVideo_CancelAssignUser.callback = function(queID,usrID)
				{
					// console.log("CRVideo_CancelAssignUser(queID:%s,usrID:%s)",queID,usrID);
					removeUserSrvLayer();

				}
				//会议创建成功
				CRVideo_CreateMeetingSuccess.callback = function(meetObj,cookie)
				{
					  console.log("CRVideo_CreateMeetingSuccess");
					  CRVideo_Call(g_call_user_id,meetObj);
					  CRVideo_AcceptAssignUser(g_call_user_que, g_call_user_id);

				}
				//会议创建失败
				CRVideo_CreateMeetingFail.callback = function(sdkErr,cookie)
				{
					console.log("CRVideo_CreateMeetingFail " );
					removeLodingLayer();
					popupTipLayer("创建会议失败")
				}
				//呼叫他人操作成功
				CRVideo_CallSuccess.callback = function(callID, cookie)
				{
					// console.log("CRVideo_CallSuccess(callID:%s)",callID);
					CRVideo.CallID =   callID;

				}
				//呼叫他人操作失败
				CRVideo_CallFail.callback = function(callID, sdkErr,cookie)
				{
					// console.log("CRVideo_CallFail(callID:%s,sdkErr:%s)",callID,sdkErr);
					removeLodingLayer();
					popupTipLayer("呼叫失败");
				}

				//通知呼叫被对方接受
				CRVideo_NotifyCallAccepted.callback = function(callID,meetObj,usrExtDat)
				{
					 
					g_meet_id = meetObj.ID;
					g_meet_pwd = meetObj.pswd;
					g_session_call_id = callID;
					console.log("CRVideo_NotifyCallAccepted " + callID);
					CRVideo_EnterMeeting(g_meet_id,g_meet_pwd,g_user_id,g_nick_name);
				}
				//通知呼叫被对方拒绝
				CRVideo_NotifyCallRejected.callback = function(callID, sdkErr,usrExtDat)
				{
					// console.log("CRVideo_NotifyCallRejected(callID:%s,sdkErr:%s)",callID,sdkErr);
					removeLodingLayer();
					popupTipLayer("呼叫被对方拒绝");
				}
	
				//------------------------------
				//
				//登录处理
				//
				//------------------------------
				//登录成功
				CRVideo_LoginSuccess.callback = function(usrID,cookie)
				{
					// console.log("CRVideo_LoginSuccess(usrID:%s)",usrID);
					removeLodingLayer();
					g_me_user_id = g_user_id;
					CRVideo.sessionID= usrID;
					//初始化队列数据
					 
					CRVideo_InitQueueDat();
					$('.login_containt').css('display',"none");
					//根据登陆的角色显示对应的用户界面
					if(g_login_type == 1) //客户
					{
						$('.queue_containt').css('display',"block");
						$('.queue_username').text('欢迎'+g_me_user_id+'...')
						
					}
					else if(g_login_type == 2)	//坐席
					{
						
						$('.start_server_containt').css('display',"block");
						$('.start_server_username').text(g_me_user_id+'...')
					}
					
	

				}
				//登录失败
				CRVideo_LoginFail.callback = function(sdkErr,cookie)
				{
					
					// console.log("CRVideo_LoginFail(sdkErr:%s)",sdkErr);
					removeLodingLayer();
					popupTipLayer('登录失败:'+ sdkErr);

				}
			 
				//登录
				$('.login_button').click(function()
				{

					if(!g_is_init)//插件是否初始化
					{
						//初始化sdk
						var result = CRVideo_Init2(g_location_dir);
						if(result == "0"){
							g_is_init = true
						}
						
					}

					
					g_server_addr = $('#login_server_name').val();
					g_user_id = $('#login_name_name').val();
					g_nick_name = $('#login_name_name').val();

					if($('#login_style_name').val() == '坐席')
					{
						g_login_type = 2;
					}else
					{
						g_login_type = 1;
					}
					
					
					
				    cr_account = sessionStorage.getItem("login_cpyname_name") || $("#login_cpyname_name").val() || "demo@cloudroom.com";
					//密码
					cr_psw = "e10adc3949ba59abbe56e057f20f883e";
					if(!g_user_id)
					{
						popupTipLayer('用户名不能为空' );
						return 
					}else if(g_user_id.length > 10)
					{
						popupTipLayer('用户名过长' );

						return 
					}else if(!g_login_type)
					{
						popupTipLayer('用户类型不能为空' );

						return 
					}else if(!g_server_addr)
					{
						popupTipLayer('服务器地址不能为空' );

						return 
					}else
					{
						CRVideo_SetServerAddr(g_server_addr);
						//CRVideo_GetCallServerInfo(g_server_addr,cr_account,cr_psw);
						CRVideo_Login(cr_account,cr_psw,g_nick_name,g_user_id,"");
					}
					popupLodingLayer();
        });
        // 暂时保存用户名更改 直到关闭页面
        $('#login_cpyname_name').change(function () {
          sessionStorage.setItem("login_cpyname_name",$("#login_cpyname_name").val());
        })

		</script>
	</body>
</html>