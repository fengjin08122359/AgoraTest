
var g_is_init = false; // 是否初始化
var g_server_addr; // 服务器地址
var g_user_id; // 登录用户id
var g_nick_name; // 登录昵称
var g_master; // 是否是主持人身份 1-是 0-否
var g_logining = false; // 是否登录
var g_meeting = false; // 是否在会议中
var g_meet_id; // 视频会议ID
var g_meet_number; // 会议号
var g_meet_pswd; // 本次会议中的密码
var g_meet_video; // 主视频
var g_main_id; // 主视频的ID
var g_me_user_id; // 自己的ID
var g_meet_video1; // 参会者的视频
var g_meet_video2; // 参会者的视频
var g_meet_video3; // 参会者的视频
var g_meet_video4; // 参会者的视频
var g_meet_video5; // 参会者的视频
var getVideoList; // 所有的摄像头
var g_meet_mode; // 视频墙分屏 2-二分屏 3-四分屏 5-六分屏
var video_size_arr=[[0,0,0],[144,80,56],[224,128,72],[288,160,100],[336,192,150],[448,256,200],[512,288,250],[576,320,300],[640,360,350],[720,400,420],[848,480,500],[1024,576,650],[1280,720,1000],[1920,1080,2000]]; // 视频码率
var g_video_size_type = 8;
var g_video_fps = 15;
var g_video_qp = 0;
var g_wh_rate = 0; // 尺寸比例
var g_chat_id;
var g_meScreenShare = false;     //自己是否开启
var g_otherScreenShare = false;  //他人是否开启
var g_bg_color = 0;
var g_residual_timer = -1;
var g_muti_video = 0; // 是否启用多摄像头 1-开启 0-关闭
var g_current_page; // 当前功能页 视频墙-0 共享-1 白板-2
var g_screenShareObj; // 屏幕共享对象
var g_is_first_meeting = 0;
var cr_account; // 云屋授权账号
var cr_psw;//云屋授权密码
var g_isStartScreenShare = false;
var g_screenShareX = 0;
var g_screenShareY = 0;
var g_screenShareWidth = 0;
var g_screenShareHeight = 0;
var g_file_layout = -1;

var g_location_dir = function() {
	var location_dir = location.href;
	var end = location_dir.lastIndexOf('/');
	var start = location_dir.indexOf('file:///');
	if(start > -1) {
		start = 8;
	}else {
		start = 0;
	}
	location_dir = location_dir.slice(start,end)+"/home/";
	location_dir = decodeURIComponent(location_dir);
	return location_dir;
}()

var param = function(){
  var src = location.href;
  // 解析参数并存储到 settings 变量中
  var arg = src.indexOf('?') !== -1 ? src.split('?').pop() : '';
  var settings = {};
  arg.replace(/(\w+)(?:=([^&]*))?/g, function(a, key, value) {
    settings[key] = value;
  });
  return settings;
}()

var  loginMetting = function () {
	// 插件是否初始化
	if(!g_is_init) {
		var result = CRVideo_Init2(g_location_dir);
		if(result == CRVideo_WEB_OCX_NOTINSTALLED) {
			// 没有安装
			alert("没有安装插件");
			return;
		} else if(result == CRVideo_OCX_VERSION_NOTUPPORTED) {
			// 版本过低
			alert("插件版本过低");
			return;
		} else if(result == CRVideo_WEB_BROWER_NOTUPPORTED) {
			// 不支持的浏览器
			alert("不支持的浏览器");
			return;
		} else if(result != 0) {
			// 其他错误
			alert("CRVideo_init sdkErr:"+result);
			return;
		} else {
			g_is_init = true;
		}
	}
	
	g_server_addr = 'www.cloudroom.com';
	g_user_id = param["visitorId"] || 'visitorId';
	g_nick_name = param["visitorId"] || 'visitorId';
	// 云屋授权账号
	cr_account = "demo@cloudroom.com";
	// 云屋授权账号的密码
	cr_psw =   "e10adc3949ba59abbe56e057f20f883e";
  
  g_master = 1;

  CRVideo_SetServerAddr(g_server_addr);
  CRVideo_Login(cr_account,cr_psw,g_nick_name,g_user_id,"");
}

var createMeeting = function(m_name){
  if (param["meetId"]) {
    enterMetting(param["meetId"])
  } else {
    CRVideo_CreateMeeting(m_name);
  }
}

var enterMetting = function(m_number){
  g_meet_number = m_number;
  CRVideo_EnterMeeting(g_meet_number,"",g_user_id,g_nick_name);	
}
var createScreenShareObj = function(){
  if(g_screenShareObj == null) {
    g_screenShareObj = CRVideo_CreatScreenShareObj();
    g_screenShareObj.id("screenShareObj");
    $("#screenShareContainer").append(g_screenShareObj.handler());
  }
}

var configObj = function(){
  CRVideo_SetDNDStatus(1); // 设置呼叫免打扰
  // 打开摄像头
  CRVideo_OpenVideo(g_user_id);
  // 默认关闭多摄像头
  CRVideo_SetEnableMutiVideo(g_user_id,g_muti_video);
  // 打开麦克风
  CRVideo_OpenMic(g_user_id);
  // 初始化音频设备
  var cfg = {};
  cfg.micName = "";
  cfg.speakerName = "";
  cfg.privAgc = 0;
  cfg.privEC =0;
  CRVideo_SetAudioCfg(cfg);
}
// 设置摄像头参数
function updateVideoCfg(sizeType,fps,qp,rate) {
	var cfg = {};
	cfg.sizeType = sizeType;
	var fps = parseInt($("#frame_ipt").val());
	if(fps < 5) {
		fps = 5;
	} else if(fps > 20) {
		fps = 20;
	}
	cfg.fps = fps;
	cfg.maxbps = video_size_arr[sizeType][2]*1000;
	if(qp == 1) {
		cfg.qp_min = 22;
		cfg.qp_max = 36;
	} else if(qp == 0) {
		cfg.qp_min = 22;
		cfg.qp_max = 25;
	}
	cfg.wh_rate = rate;
	CRVideo_SetVideoCfg(cfg);
}

// 屏幕共享
var showScreenShareSet = function(){
	if(g_otherScreenShare || g_meScreenShare) {
		alert("正在屏幕共享中");
		return;
	}

	var str = '<div id="shareScreenSet" class="share_screen_set">'
		    + '<div id="shareScreenSetType" class="share_screen_set_type">'
				+'<span class="share_screen_set_type1">'
					+ '<input type="radio" onclick="choseShareTY(\'0\')"  name="chooseScreenType"  class="choose_screen_type" value="0" checked="checked"/>'
				    + '<label>屏幕共享</label>'
				+'</span>'
				+'<span class="share_screen_set_type1">'
					+'<input type="radio"  onclick="choseShareTY(\'1\')"  name="chooseScreenType" class="choose_screen_type" value="1"/>'
					+'<label>区域共享</label>'
				+'</span>'
			+'</div>'
			+'<div id="shareScreenSetFirst" class="share_screen_set_first">'
				+'<span class="share_screen_set_type1">'
					+'<input type="radio"  onclick="choseShareFR(\'0\')"  name="chooseScreenFirst"  class="choose_screen_first" value="0" checked="checked"/>'
					+'<label>画质优先</label>'
			    +'</span>'
			    +'<span class="share_screen_set_type1">'
					+'<input type="radio" onclick="choseShareFR(\'1\')" name="chooseScreenFirst" class="choose_screen_first" value="1"/>'
					+'<label>速度优先</label>'
				+'</span>'
			+'</div>'
		+'</div>'	
	layui.use('layer', function() {
			var layer = layui.layer;
			layer.open({
			type: 1,
  			skin: 'layui-layer-rim', //加上边框
			shadeClose: true,
			closeBtn: 0,
			area: ['400px', '200px'],
			title: false,
			content: str,
			btn: ['开始共享'],
			yes: function(index){
				 	var obj = {}
	                var encodeType = $("input[name='chooseScreenFirst']:checked").val();
	                var catchRect =  $("input[name='chooseScreenType']:checked").val();
	                obj.encodeType = encodeType;
	                if(catchRect == "1")
	                {
	                    obj.catchRect = {"left":100,"top":100,"width":500,"height":400}
	                }else
                    {
                        g_screenShareX = 0;
                        g_screenShareY = 0;
                    }
	                CRVideo_SetScreenShareCfg(obj);
	                CRVideo_StartScreenShare();
					layer.close(index);
				},
			end:function(){
			},
			success: function(layero, index){
				$(layero).find('.layui-layer-content').css("height","152px");
			},
			btnAlign: 'c'
		});

	});
};


function choseShareTY(num){
	// radio 在选择时的变化
	if(num == "0"){
		$("input[name='chooseScreenType']").eq(1).attr("checked",false);
		$("input[name='chooseScreenType']").eq(0).attr("checked",true);
	}else if(num == "1"){
		$("input[name='chooseScreenType']").eq(0).attr("checked",false);
		$("input[name='chooseScreenType']").eq(1).attr("checked",true);
	}
}
function choseShareFR(num){
	// radio 在选择时的变化
	if(num == "0"){
		$("input[name='chooseScreenFirst']").eq(1).attr("checked",false);
		$("input[name='chooseScreenFirst']").eq(0).attr("checked",true);
	}else if(num == "1"){
		$("input[name='chooseScreenFirst']").eq(0).attr("checked",false);
		$("input[name='chooseScreenFirst']").eq(1).attr("checked",true);
	}
}
function chosePcmTY(num){
	if(num == "0"){
		$("input[name='chosePcmType']").eq(1).attr("checked",false);
		$("input[name='chosePcmType']").eq(0).attr("checked",true);
	}else if(num == "1"){
		$("input[name='chosePcmType']").eq(0).attr("checked",false);
		$("input[name='chosePcmType']").eq(1).attr("checked",true);
	}
}

function logout() {
	CRVideo_Logout();
	setTimeout(function() {
		location.replace(location.href);
	},200);
}


// 登录成功
CRVideo_LoginSuccess.callback = function(usrID,cookie) {
	alert(usrID);
	g_me_user_id = usrID;
	g_logining = true;
  createMeeting("meetID")
}

// 登录失败
CRVideo_LoginFail.callback = function(sdkErr,cookie) {
  alert("登录失败 错误码:"+sdkErr);
}

// 创建会议成功
CRVideo_CreateMeetingSuccess.callback = function(meetObj,cookie) {
	g_meet_id = meetObj.ID;
	g_meet_pswd = meetObj.pswd;
  alert("createMeeting"+meetObj.ID)
	CRVideo_EnterMeeting(g_meet_id,g_meet_pswd,g_user_id,g_nick_name);	
}

// 创建会议失败
CRVideo_CreateMeetingFail.callback = function(sdkErr,cookie) {
	alert("创建会议失败 错误码:"+sdkErr);
}
// 进入会议的结果
CRVideo_EnterMeetingRslt.callback = function(sdkErr) {
  if(sdkErr == CRVideo_NOERR) {
    g_meeting = true;
    var meetId = g_meet_id || g_meet_number
    $("title").html("共享屏幕-"+meetId)
    createScreenShareObj();
    configObj();
    updateVideoCfg(g_video_size_type,g_video_fps,g_video_qp,g_wh_rate);
  } else {
    alert("进入会议失败 错误码:"+sdkErr);
  }
}

CRVideo_UserEnterMeeting.callback = function(usrID) {
	alert(usrID+"进入会议")
	//$("#chatsList div").remove();
}

// 某用户离开了会议
CRVideo_UserLeftMeeting.callback = function(id) {
	aler(id+"离开了会议");
	setMemberList();
}

// 开启屏幕共享的响应事件 本人开启
CRVideo_StartScreenShareRslt.callback = function(sdkErr) {
	if(sdkErr == 0) {
		g_meScreenShare = true;     //自己是否开启
    alert("开启了屏幕")
	}
}
// 通知他人开启了屏幕共享，只有当他人开启，本地展示显示的div  同时屏幕共享的红框应该隐藏
CRVideo_NotifyScreenShareStarted.callback = function() {
	g_otherScreenShare = true;
	// if(g_screenShareObj){
	// 	console.log("CRVideo_NotifyScreenShareStarted")
	// 	g_screenShareObj.clear();
	// }
	$("#screenShareContainer").css({"display":"block","left":"0px","top":"0px","width":"980px","height":"600px","overflow":"hidden"})
	g_screenShareObj.width(980);
	g_screenShareObj.height(600);
  g_screenShareObj.keepAspectRatio(1);
	CRVideo_StopScreenShare();
}


// 停止屏幕共享的响应事件 本人停止,需要将窗口关闭，将红框隐藏
CRVideo_StopScreenShareRslt.callback = function(sdkErr) {
	if(sdkErr == 0)
    {
      g_meScreenShare = false;
      $("#screenShareContainer").hide();
      g_screenShareObj.width(1);
      g_screenShareObj.height(1);
    }
}

// 通知他人停止了屏幕共享,本地的展示框应该隐藏并清除遗留残影
CRVideo_NotifyScreenShareStopped.callback = function() {
	if(g_otherScreenShare){
		g_otherScreenShare = false;
	}
	CRVideo_StopScreenShare();
	if(g_screenShareObj){
		g_screenShareObj.clear();
	}
	$("#screenShareContainer").hide();
	g_screenShareObj.width(1);
	g_screenShareObj.height(1);
	
}

window.onbeforeunload = function() {
	if(g_meeting) {
		CRVideo_ExitMeeting();
		CRVideo_SetDNDStatus(0);
	}
  if(g_is_init){
		CRVideo_Uninit();
	}
  if(g_logining){
		logout();
	}
}

loginMetting();

