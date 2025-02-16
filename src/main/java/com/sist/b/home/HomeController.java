package com.sist.b.home;


import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;

import org.springframework.security.core.context.SecurityContextImpl;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sist.b.ad.AdService;
import com.sist.b.ad.AdVO;
import com.sist.b.alarm.AlarmService;
import com.sist.b.alarm.AlarmVO;
import com.sist.b.bookmark.BookmarkService;
import com.sist.b.bookmark.BookmarkVO;
import com.sist.b.comment.CommentService;
import com.sist.b.comment.CommentVO;
import com.sist.b.likes.LikesService;
import com.sist.b.likes.LikesVO;
import com.sist.b.payments.PaymentsService;
import com.sist.b.follow.FollowService;

import com.sist.b.post.PostService;
import com.sist.b.post.PostVO;
import com.sist.b.report.ReportService;
import com.sist.b.report.ReportVO;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.servlet.ModelAndView;

import com.sist.b.user.RoleVO;
import com.sist.b.user.UserService;

import com.sist.b.user.UserVO;

@Controller
public class HomeController {
	
	@Autowired
	private PostService postService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private FollowService followService;

	@Autowired
	private ReportService reportService;

	@Autowired
	private LikesService likesService;
	
	@Autowired
	private BookmarkService bookmarkService;
	
	@Autowired
	private AlarmService alarmService;
	
	@Autowired
	private AdService adService;
	
	@Autowired
	private PaymentsService paymentsService;
	
	@GetMapping("/")
	public ModelAndView getPostList(HttpSession session)throws Exception{

		
		
		Object object = session.getAttribute("SPRING_SECURITY_CONTEXT");
		SecurityContextImpl sc = (SecurityContextImpl)object;
		Authentication authentication = sc.getAuthentication();
		UserVO userVO = (UserVO)authentication.getPrincipal();
		
		List<RoleVO> admin = userVO.getRoles();
		String viewname = "home";
		for(RoleVO roleVO: admin) {
			if(roleVO.getRoleName().equals("ROLE_ADMIN")) {
				viewname="redirect:admin/home";
			}
		}
		
		ModelAndView mv = new ModelAndView();
	
		List<PostVO> ar = postService.getPostList(userVO);
			
		LikesVO likesVO = new LikesVO();
		
		mv.addObject("postList", ar);
		
		Long followCount = followService.followCount(userVO.getUserNum());
	
		List<UserVO> users = null;
		//팔로우 한 사람이 있으면 home으로 없으면 userList로
		if(followCount==0) {
			mv.addObject("followCount", followCount);
		} 
		userVO.setUserCount(5);
		users = followService.userList(userVO);
		
		// 멤버십 가입 여부 확인
		Long userNum = paymentsService.getPaymentsCk(userVO.getUserNum());
		
		if (userNum == null) {
			mv.addObject("paymentsCk", "n");
		} else {
			mv.addObject("paymentsCk", "y");
		}
		
		mv.addObject("postList", ar);
		
		mv.addObject("users", users);
		mv.setViewName(viewname);			

		return mv;
	}
	
	@PostMapping("/")
	public ModelAndView postReport(ReportVO reportVO) throws Exception {
		ModelAndView mv = new ModelAndView();
		int result = reportService.setInsert(reportVO);
		mv.setViewName("redirect:/");
		return mv;
	}
	
	@GetMapping("/explore")
	public ModelAndView getExploreList(HttpSession session)throws Exception{
		ModelAndView mv = new ModelAndView();
		Object object = session.getAttribute("SPRING_SECURITY_CONTEXT");
		SecurityContextImpl sc = (SecurityContextImpl)object;
		Authentication authentication = sc.getAuthentication();
		UserVO loginUserVO = (UserVO)authentication.getPrincipal();
		
		List<PostVO> ar = postService.getAllList(loginUserVO);
		
		mv.addObject("postList", ar);
		mv.setViewName("post/explore");
		
		return mv;
	
	}
	
	

	@GetMapping("/{username}")
	public ModelAndView getProfile(@PathVariable String username, PostVO postVO, HttpSession session, Long alarmNum) throws Exception {
		//파라미터 username으로 가져온 userVO
		UserVO userVO = userService.getSelectOne(username);
		System.out.println("fileName : "+userVO.getFileName());
		Map<String, Long> count = new HashMap<String, Long>();
		Long followCount = followService.followCount(userVO.getUserNum());
		Long followerCount = followService.follwerCount(userVO.getUserNum());
		count.put("followCount", followCount);
		count.put("followerCount", followerCount);
		
		//로그인 되어 있는 유저의 정보를 가지고 있는 userVO
		Object object = session.getAttribute("SPRING_SECURITY_CONTEXT");
		SecurityContextImpl sc = (SecurityContextImpl)object;
		Authentication authentication = sc.getAuthentication();
	
		UserVO loginUserVO = (UserVO)authentication.getPrincipal();
		
		//게시물 userNum
		postVO.setUserNum(userVO.getUserNum());
		
		ModelAndView mv= new ModelAndView();
		
		//bookmarklist 불러오기
		List<PostVO> ar2 = postService.getBookmarkList(postVO);
		
		mv.addObject("bookmarkList", ar2);
		
		//profile postList 불러오기
		List<PostVO> ar = postService.getUserProfile(postVO);;
		
		//팔로우가 0이면 내가 팔로우 하고 있지 않은 사람
		//팔로우가 1이면 내가 팔로우 하고있는 사람
		int follow = 0;
		if(userVO.getUsername().equals(loginUserVO.getUsername())) {	
			mv.setViewName("myProfile");
		} else {
			if(followService.followCheck(userVO, session)) {
				follow = 1;
			}
			mv.addObject("follow", follow);
			mv.setViewName("profile");
		}
		
		// 알림 읽음 처리
		int result = alarmService.setUpdate(alarmNum);
		
		mv.addObject("postcount", ar.size());
		
		mv.addObject("postlist", ar);

		mv.addObject("count", count);

		mv.addObject("fromUserNum", loginUserVO.getUserNum());

		mv.addObject("userVO", userVO);
		
		return mv;
	}
	


	@ResponseBody
	@GetMapping("insertLikes.do")
	public PostVO setLikesInsert(@RequestParam Long no, LikesVO likesVO, HttpSession session)throws Exception {
		
		Object object = session.getAttribute("SPRING_SECURITY_CONTEXT");
		SecurityContextImpl sc = (SecurityContextImpl)object;
		org.springframework.security.core.Authentication authentication =sc.getAuthentication(); 
		UserVO userVO = (UserVO)authentication.getPrincipal();

	
		
		likesVO.setUserNum(userVO.getUserNum());
		likesVO.setPostNum(no);
	
		PostVO postVO = likesService.setLikesInsert(likesVO);
		
		// 알림 추가
		AlarmVO alarmVO = new AlarmVO();
		// 좋아요 알림 : 1
		alarmVO.setAlarmType(1);
		alarmVO.setFromUserNum(userVO.getUserNum());
		
		// userNum 조회
		Long toUserNum = postService.getUserNum(no);
		
		alarmVO.setToUserNum(toUserNum);
		alarmVO.setTargetPostNum(no);
		
		// 좋아요 알림 insert
		int result = alarmService.setInsert(alarmVO);
		
		return postVO;
		
	}
	
	@ResponseBody
	@GetMapping("deleteLikes.do")
	public PostVO setLikesDelete(@RequestParam Long no, LikesVO likesVO, HttpSession session)throws Exception {
		
		Object object = session.getAttribute("SPRING_SECURITY_CONTEXT");
		SecurityContextImpl sc = (SecurityContextImpl)object;
		org.springframework.security.core.Authentication authentication =sc.getAuthentication(); 
		UserVO userVO = (UserVO)authentication.getPrincipal();
		
		likesVO.setUserNum(userVO.getUserNum());
		likesVO.setPostNum(no);
	
		PostVO postVO = likesService.setLikesDelete(likesVO);
		
		return postVO;
		
	}
	
	@ResponseBody
	@GetMapping("getLikeUser.do")
	public ModelAndView getLikeUser(@RequestParam Long no, LikesVO likesVO)throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		likesVO.setPostNum(no);
		
		List<LikesVO> ar = likesService.getLikeUser(likesVO);
		
		mv.addObject("likeuser", ar);
		mv.setViewName("ajaxLikeList");
		
		return mv;
		
	}
	
	
	
	@ResponseBody
	@GetMapping("insertBookmark.do")
	public int setBookmarkInsert(@RequestParam Long no, BookmarkVO bookmarkVO, HttpSession session)throws Exception {
		
		Object object = session.getAttribute("SPRING_SECURITY_CONTEXT");
		SecurityContextImpl sc = (SecurityContextImpl)object;
		org.springframework.security.core.Authentication authentication =sc.getAuthentication(); 
		UserVO userVO = (UserVO)authentication.getPrincipal();

	
		
		bookmarkVO.setUserNum(userVO.getUserNum());
		bookmarkVO.setPostNum(no);
	
		int result = bookmarkService.setBookmarkInsert(bookmarkVO);
		
		return result;
		
	}
	
	@ResponseBody
	@GetMapping("deleteBookmark.do")
	public int setBookmarkDelete(@RequestParam Long no, BookmarkVO bookmarkVO, HttpSession session)throws Exception {
		
		Object object = session.getAttribute("SPRING_SECURITY_CONTEXT");
		SecurityContextImpl sc = (SecurityContextImpl)object;
		org.springframework.security.core.Authentication authentication =sc.getAuthentication(); 
		UserVO userVO = (UserVO)authentication.getPrincipal();
		
		bookmarkVO.setUserNum(userVO.getUserNum());
		bookmarkVO.setPostNum(no);
	
		int result = bookmarkService.setBookmarkDelete(bookmarkVO);
		
		return result;
		
	}
	

	@PostMapping("/{username}")
	public ModelAndView getProfile(@PathVariable String username, HttpSession session, ReportVO reportVO) throws Exception {
		ModelAndView mv = new ModelAndView();
		//파라미터 username으로 가져온 userVO
		UserVO userVO = userService.getSelectOne(username);
		Object object = session.getAttribute("SPRING_SECURITY_CONTEXT");
		SecurityContextImpl sc = (SecurityContextImpl)object;
		Authentication authentication = sc.getAuthentication();
		// 신고 정보 insert
		int result = reportService.setInsert(reportVO);
		
		mv.addObject("userVO", userVO);
		mv.setViewName("profile");
		return mv;
	}
	
	@GetMapping("/getSearchUser")
	public ModelAndView getSearchUser(String searchText, HttpSession session) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		Object object = session.getAttribute("SPRING_SECURITY_CONTEXT");
	    SecurityContextImpl sc = (SecurityContextImpl)object;
	    Authentication authentication = sc.getAuthentication();
	    UserVO userVO = (UserVO)authentication.getPrincipal(); 
		
		List<UserVO> list = userService.getSaerchUser(userVO, searchText);
		
		PostVO postVO  = new PostVO();
		
		postVO.setTag(searchText+" ");
		
		Long tag_count = postService.getSearchTagCount(postVO);
		List<PostVO> taglist = postService.getTagList(postVO);
		
		
		mv.addObject("searchUserList", list);
		mv.addObject("taglist", taglist);
		mv.addObject("tag_count", tag_count);
		mv.addObject("searchText", searchText);
		
		mv.setViewName("temp/searchUserList");
		return mv;
	}
	
	@RequestMapping("/search/tag/{word}")
	public ModelAndView serachTag(@PathVariable("word") String word)throws Exception{
		ModelAndView mv = new ModelAndView();

		PostVO postVO = new PostVO();
		
		postVO.setTag(word+" ");
		
		Long tag_cnt = postService.getSearchTagCount(postVO);
		
		
		List<PostVO> tagList = postService.getTagList(postVO);
		
		mv.addObject("tag_cnt", tag_cnt);
		mv.addObject("tag", tagList);
		mv.addObject("word", word);
		mv.setViewName("tag");
		
		return mv;
	}
	
	@GetMapping("ad")
	public ModelAndView getRandomAd() throws Exception {
		ModelAndView mv = new ModelAndView();
		AdVO adVO = adService.getRandomAd();
		mv.addObject("adVO", adVO);
		mv.setViewName("ad/popup");
		return mv;
	}

}
