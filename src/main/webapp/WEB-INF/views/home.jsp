<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>   

<!DOCTYPE html>
<html>
<head>
<title>HOME</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/home.css">
<c:import url="./temp/head.jsp"></c:import>

<script type="text/javascript">
$(document).ready(function() { // 페이지가 준비되면
	likeview(); // 함수 likeview ㄱ
});
</script>

</head>
<body>

   
	<c:import url="./temp/nav2.jsp"></c:import>
		<script type="text/javascript">
			$("#home").attr("src", "${pageContext.request.contextPath}/static/icons/home-click.png");
		</script>
	
	<!-- main page -->
		<main>
			
			<!-- left feed area -->
			<sec:authentication property="principal" var="userVO"/>
			<div class="main_feed">
				
				<!-- post foreach, db 추가 -->
				
				<c:forEach items="${postList}" var="list">
				<article style="   border: 1px solid #DBDBDB; margin-bottom: 60px;">
					<!-- post header -img, nickname, more -->
					<header>
						<div class="post_profile">
							<img class="post_profile_img pic" alt="profile"  src="${pageContext.request.contextPath}/static/icons/user.jpg">
							<span class="nickname main_nickname point_span">
								
							${list.userVO.username}
							</span>
					
						<img class="icon_react icon_more" id="more" data-postNum="${list.postNum }" style="margin-left: 570px; position:absolute; cursor: pointer;" alt="more" src="${pageContext.request.contextPath}/static/icons/more.png">
			
						</div>
					</header>
					<!--//header  -->
					
					
					
					<!-- post image -->
					<div class="post_image swiper mySwiper" style="margin-left: -1px; width: 613px;">
			
							
						<div class="swiper-wrapper">
						<c:forEach items="${list.fileList}" var="fileVO">
							
							<img class="post swiper-slide" alt="post" src="${pageContext.request.contextPath}/static/upload/post/${fileVO.postfileName}">
							
						</c:forEach>
							</div>
				
						<div class="swiper-button-next"></div>
      					<div class="swiper-button-prev"></div>
      					<div class="swiper-pagination"></div>		
					</div>

					
					<!-- post icon -->
					<div class="icons_react">
						<div class="icons_left">
					
						<c:choose>
						
							<c:when test="${empty list.likesVO.count}">
								<a data-idx ="${list.postNum}" class="heart-click heart_icon${list.postNum}"> 
									<img class="icon_react like_untouched" id="like" alt="heart" src="${pageContext.request.contextPath}/static/icons/heart.png">
								</a>
								
							</c:when>
							
							<c:otherwise>
								
								<a data-idx ="${list.postNum}" class="heart-click heart_icon${list.postNum}"> 
									<img class="icon_react like_touched" id="like" alt="heart" src="${pageContext.request.contextPath}/static/icons/heart-click.png">
								</a>
							</c:otherwise>
						
						</c:choose>
				
							
						<a href="./post/selectOne?postNum=${list.postNum}">
							<img class="icon_react" alt="speech" src="${pageContext.request.contextPath}/static/icons/bubble-chat.png">
						</a>
						</div>
						
							<c:choose>
						
							<c:when test="${empty list.bookmarkVO.chk}">
								<a data-idx ="${list.postNum}" class="bookmark-click bookmark_icon${list.postNum}"> 
									
									<img class="icon_react bookmark_untouched" alt="bookmark" src="${pageContext.request.contextPath}/static/icons/bookmark.png">
								</a>
								
							</c:when>
							
							<c:otherwise>
								
								<a data-idx ="${list.postNum}" class="bookmark-click bookmark_icon${list.postNum}"> 
									
									<img class="icon_react bookmark_untouched" alt="bookmark" src="${pageContext.request.contextPath}/static/icons/bookmark-click.png">
								</a>
							</c:otherwise>
						
						</c:choose>
				
						
				
					
					
					</div>
					
					<!-- text  -->
					<div class="reaction">
			            <div class="liked_people">
			       
			              <p id="count_text"><span class="point-span" id="m_likes${list.postNum }" style="font-weight: bold;">${list.likes}</span>명이 좋아합니다</p>
			    
			            </div>
			            <div class="box">
			            	<div class="description">
				              <span class="point_span nickname" style="font-weight: 600;">${list.userVO.username }</span> ${list.contents }
			            		<span class="tag">${list.tag }</span>
			            	</div>
			            </div>
			            
			            <!-- comments -->
			  
			              <div class="time_log" style="margin-top: 10px; margin-bottom: 10px;">
			                <span>${list.regDate}</span>
			              </div>
			          </div>   
			          
			
				</article>
			
				</c:forEach>
			
				<!--//post  -->
				
						
			</div>
			
			<!--//left area -->
			
			<!-- right area -->
			
			<div class="right_contents">
				
				<div class="myProfile">
				
					<c:choose>
						<c:when test="${not empty userVO.fileName }">
							<a href="/gram/${userVO.username}">
								<img class="pic my_img" alt="myprofile" src="${pageContext.request.contextPath}/static/upload/user/${userVO.fileName}">
							
							</a>
						</c:when>
						<c:otherwise>
							<a href="/gram/${userVO.username}">
								<img class="pic my_img" alt="myprofile" src="${pageContext.request.contextPath}/static/icons/user.jpg">
							</a>
						</c:otherwise>
					</c:choose>
					<div>
					

						<a class="nickname point_span" href="/gram/${userVO.username}">${userVO.username }</a>
						<!-- span username 추가 -->
						<span class="sub_span">${userVO.nickname }</span>

					</div>
				</div>
			
				<!-- recommendation section -->
				<!-- 신규순 추천 -->
				<div class="section_recommend">
					<div class="recommend_title">
						<span class="sub-title">회원님을 위한 추천</span>
						<a class="all_recommend_list" href="/gram/friendships/people" tabindex="0">
							<div class="all-recommend-title">모두 보기</div>
						</a>
					</div>							
					<!-- recommend list -->
					<ul class="recommend_list">
						<c:forEach items="${users}" var="user">
							<li><!-- foreach -->
								<div class="recommend_profile">
									<c:choose>
										<c:when test="${not empty user.fileName }">
											<a href="/gram/${user.username }">
												<img class="post_profile_img" alt="profile_img" src="${pageContext.request.contextPath}/static/upload/user/${user.fileName}">
											</a>
										</c:when>
										<c:otherwise>
											<a href="/gram/${user.username }">
												<img class="post_profile_img" alt="profile_img" src="${pageContext.request.contextPath}/static/icons/user.jpg">
											</a>
										</c:otherwise>
									</c:choose>
									<div class="profile_text">
										<a class="nickname point_span username_link" href="/gram/${user.username}">${user.username }</a>
										<span class="sub_span">${user.nickname}</span>
									</div>
								</div>
								<button class="btn_follow recommend_follow" id="btn_follow" type="button" data-user-num="${userVO.userNum}" data-follow-num="${user.userNum}">팔로우</button>
								<button class="btn_following recommend_following" id="btn_following" type="button" data-user-num="${userVO.userNum}" data-follow-num="${user.userNum}" style="display: none;">팔로잉</button>
							</li>
						</c:forEach>
					</ul>

				</div>
				
			
				<!-- footer 추가 -->
				
				 <footer>
		          <p class="insta-sccript">
		            <a href="https://about.instagram.com/" class="link">소개</a> ∙ 
		            <a href="https://help.instagram.com/" class="link">도움말</a> ∙ 
		            <a href="https://about.instagram.com/blog/" class="link">홍보 센터</a> ∙ 
		            <a href="https://developers.facebook.com/docs/instagram" class="link">API</a> ∙ 
		            <a href="https://about.instagram.com/about-us/careers" class="link">채용 정보</a> ∙<br> 
		            <a href="https://help.instagram.com/519522125107875" class="link">개인정보처리방침</a> ∙ 
		            <a href="https://help.instagram.com/581066165581870" class="link">약관</a> ∙ 
		            <a href="https://www.instagram.com/explore/locations/" class="link">위치</a> ∙ 
		            <a href="https://www.instagram.com/directory/profiles/" class="link">인기계정</a> ∙ 
		            <a href="https://www.instagram.com/directory/hashtags/" class="link">해시태그</a>
		            <br><br>
		            © 2020 INSTAGRAM FROM FACEBOOK
		          </p>
		        </footer>
		        
		        <!-- 상단 이동 -->
		        
		        <img class="top" alt="top" onclick="clickme()" src="${pageContext.request.contextPath}/static/icons/top.png">
			</div>
			
			
		</main>
		
		<div class="modal">
		<div class="modal_content">
			<button type="button" id="suspend">
				<h1>신고</h1>
			</button>
			<button type="button" id="cancel">취소</button>
		</div>
	</div>
	
	<div class="modal2">
		<div class="modal_content2">
			<div id="d1">
				<span class="c">
					<h1 id="d1_t1">게시물을 신고할까요?</h1> 
					<span id="d1_t2">이 게시물을 신고하시겠어요?</span>
				</span>
			</div>
			<div id="d2">
				<h1 class="c" id="d2_del">신고</h1>
			</div>
			<div id="d3">
				<span class="c" id="d3_can">취소</span>
			</div>
		</div>
	</div>
	
	
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/follow.js"></script>
	<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
    <script type="text/javascript">
    
    $('.box').each(function(){
        var content = $(this).children('.description');
        var content_txt = content.text();
        var content_txt_short = content_txt.substring(0,100)+"...";
        var btn_more = $('<a href="javascript:void(0)" class="more">더보기</a>');

        
        $(this).append(btn_more);
        
        if(content_txt.length >= 100){
            content.html(content_txt_short)
            
        }else{
            btn_more.hide()
        }
        
        btn_more.click(toggle_content);
      

        function toggle_content(){
            if($(this).hasClass('short')){
                // 접기 상태
                $(this).html('더보기');
                content.html(content_txt_short)
                $(this).removeClass('short');
            }else{
                // 더보기 상태
                $(this).html('접기');
                content.html(content_txt);
                $(this).addClass('short');

            }
        }
    });
    
   	function clickme() {
   	  window.scrollTo({top:0, left:0, behavior:'smooth'});
   	}
   	
   	$( window ).scroll( function() {
   		if ( $( this ).scrollTop() > 200 ) {
   			$( '.top' ).fadeIn("fast");
   		} else {
   			$( '.top' ).fadeOut("fast");
   		}
   	} );
   	
   	
   	 var swiper = new Swiper(".mySwiper", {
        spaceBetween: 30,
        effect: "fade",
        navigation: {
          nextEl: ".swiper-button-next",
          prevEl: ".swiper-button-prev",
        },
        pagination: {
          el: ".swiper-pagination",
          clickable: true,
        },
 
      });
   	 
   	 
   	$(".heart-click").click(function() {

   	    // 게시물번호 idx로 전달받아 저장
   	    var no = $(this).data('idx');
   	    console.log(no);

   	    // 빈하트를 눌렀을때
   	    if($(this).children('img').attr('class') == "icon_react like_untouched"){
   	        console.log("빈하트 클릭" + no);

   	        $.ajax({
   	            url : './insertLikes.do',
   	            type : 'get',
   	            data : {
   	                no : no,
   	            },
   	            success : function(postVO) {
   	               
   	            	let likes =postVO.likes;
   	    
   	            	$('#m_likes'+no).text(likes);
   	            	
   	            
   	            },
   	            error : function() {
   	                alert('서버 에러');
   	            }
   	        });

   	        $(this).html("<img class='icon_react like_touched' id='like' alt='heart' src='${pageContext.request.contextPath}/static/icons/heart-click.png'>");

   	    // 꽉찬 하트를 눌렀을 때
   	    }else if($(this).children('img').attr('class') == "icon_react like_touched"){

   	        $.ajax({
   	            url : './deleteLikes.do',
   	            type : 'get',
   	            data : {
   	                no : no,
   	            },
   	            success : function(postVO) {
					
   	            	let likes =postVO.likes;
   	            
	   	            $('#m_likes'+no).text(likes);
   	            	
   	            },
   	            error : function() {
   	                alert('서버 에러');
   	            }
   	        });

   	        // 빈하트로 바꾸기
   	      
   	     $(this).html("<img class='icon_react like_untouched' id='like' alt='heart' src='${pageContext.request.contextPath}/static/icons/heart.png'>");
   	    }



   	});
   	
   	
  	$(".bookmark-click").click(function() {

   	    // 게시물번호 idx로 전달받아 저장
   	    var no = $(this).data('idx');
   	    console.log(no);

   	    if($(this).children('img').attr('class') == "icon_react bookmark_untouched"){
   	  

   	        $.ajax({
   	            url : './insertBookmark.do',
   	            type : 'get',
   	            data : {
   	                no : no,
   	            },
   	            success : function(data) {
   	               
   	            	console.log("북마크 추가");
   	            
   	            },
   	            error : function() {
   	                alert('서버 에러');
   	            }
   	        });
   	        
   	        $(this).html("<img class='icon_react bookmark_touched' alt='bookmark' src='${pageContext.request.contextPath}/static/icons/bookmark-click.png'>");

   	    }else if($(this).children('img').attr('class') == "icon_react bookmark_touched"){

   	        $.ajax({
   	            url : './deleteBookmark.do',
   	            type : 'get',
   	            data : {
   	                no : no,
   	            },
   	            success : function(data) {

   	            	console.log("북마크 삭제");
   	            	
   	            },
   	            error : function() {
   	                alert('서버 에러');
   	            }
   	        });

   	      
   	      
   	     $(this).html("<img class='icon_react bookmark_untouched' alt='bookmark' src='${pageContext.request.contextPath}/static/icons/bookmark.png'>");
   	    }



   	});
  	
  	var postNum = 0;
  	 
  	$(document).on("click", "#more",function(){
  		$(".modal").fadeIn();
  		// 스크롤 제한 on
  		$('html, body').css({'overflow': 'hidden', 'height': '100%'});
  		postNum = (this).getAttribute('data-postNum');
  	});

  	$("#cancel").click(function(){
  		$(".modal").fadeOut();
  		// 스크롤 제한 off
  		$('html, body').css({'overflow': 'auto', 'height': 'auto'});
  	});

  	$("#suspend").click(function(){
  		$(".modal2").fadeIn();
  	});

  	$("#d2").click(function(){
  		/* 신고게시판 이동 */
  	});

  	$("#d3").click(function(){
  		$(".modal").fadeOut();
  		$(".modal2").fadeOut();
  		// 스크롤 제한 off
  		$('html, body').css({'overflow': 'auto', 'height': 'auto'});
  	});
  	


	
 </script>




</body>
</html>