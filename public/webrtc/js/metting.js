var g_is_init = false;
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
var init = function () {
  var result = CRVideo_Init2(g_location_dir);
  if(result == CRVideo_OCX_VERSION_NOTUPPORTED){
    alert("不支持的浏览器");
  }else if(result == CRVideo_WEB_BROWER_NOTUPPORTED){
    alert("rtcsdk版本过低");
  }else if(result != 0){
    alert("CRVideo_init sdkErr"+"出错了"+result);
  }else if(result == "0"){
    g_is_init = true;
    login()
  }
}

var g_server_addr = "www.cloudroom.com"
var cr_account = "demo@cloudroom.com"
var g_nick_name = param["nickName"] || "nickName"
var cr_psw = "e10adc3949ba59abbe56e057f20f883e";
var g_user_id = g_nick_name
var login = function () {
  CRVideo_SetServerAddr(g_server_addr);
  //CRVideo_GetCallServerInfo(g_server_addr,cr_account,cr_psw);
  CRVideo_Login(cr_account,cr_psw,g_nick_name,g_user_id,"");
}
//登陆成功 
CRVideo_LoginSuccess.callback = function(userID,cookie){
  //登录成功，开始创建视频会话，见下一步
  createMetting()
  console.log(userID);
}

//登录失败 
CRVideo_LoginFail.callback = function(sdkErr,cookie){

   //登录出错，可以弹出错误提示，或调用登录接口再次重试登录
}



var metting_name = param["meeting"] || ""
var g_meet_id = param["meetingId"] || ""
var createMetting = function () {
  if (g_meet_id) {
    addMetting();
  }
  CRVideo_CreateMeeting(g_server_addr,cr_account,cr_psw,metting_name)
}
//创建会议成功
CRVideo_CreateMeetingSuccess.callback=function(meetObj,cookie){
  g_meet_id = meetObj.ID;
  g_meet_pwd = meetObj.pswd;
  addMetting()
}

//创建会议失败
CRVideo_CreateMeetingFail.callback = function(sdkErr,cookie){

}

//监控会议掉线
CRVideo_MeetingDropped.callback=function(){

}

//会议掉线
CRVideo_LineOff.callback=function(sdkErr){

}

var addMetting = function () {
  CRVideo_EnterMeeting(g_meet_id ,cr_psw,g_user_id,g_nick_name)
}

//进入会议完成响应
CRVideo_EnterMeetingRslt.callback=function(sdkErr){

}

init();