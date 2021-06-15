package com.foubaby.controller;

import com.foubaby.domain.Employee;
import com.foubaby.service.EmployeeService;
import com.foubaby.utils.Msg;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class EmployeeController {

    @Autowired
    private EmployeeService employeeService;

    /**
     * 构造一个分页查询『引入pageHelper插件』
     *
     * @param pn
     * @param model
     * @return
     */
    //@RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn", defaultValue = "1") Integer pn,
                          Model model) {
        // 在你需要进行分页的 MyBatis 查询方法前调用 PageHelper.startPage 静态方法即可，
        // 紧跟在这个方法后的第一个MyBatis 查询方法会被进行分页。
        // 在查询之前只需要调用 传入页码，以及每页的大小
        PageHelper.startPage(pn, 5);
        List<Employee> emps = employeeService.getAll();
        // 使用PageInfo包装查询出来的结果，只需要将PageInfo交给页面就可以
        // 里面封装了详细的分页信息，包括我们查询出来的数据，以及要连续显示的页数等等
        PageInfo pageInfo = new PageInfo(emps, 5);
        // 然后将查询到的对象 pageInfo 封装到 model对象中就会跟随请求一起转发
        model.addAttribute("pageInfo", pageInfo);
        return "list";
    }

    /**
     * 新的接收 /emps 请求的控制器方法， 以 PageInfo 对象的方式返回数据，并且添加ResponseBody
     * 标签会将对象转换成 JSon字符串返回客户端，但是注意进行JSon格式转换， 需要添加JackSon2依赖
     *
     * @param pn
     * @return
     */
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(
            @RequestParam(value = "pn", defaultValue = "1") Integer pn) {

        // 在查询之前只需要调用 传入页码，以及每页的大小
        PageHelper.startPage(pn, 5);
        // startPage 后面紧跟的这个查询就是分页查询
        List<Employee> emps = employeeService.getAll();
        // 使用PageInfo包装查询出来的结果，只需要将PageInfo交给页面就可以
        // 里面封装了详细的分页信息，包括我们查询出来的数据，以及要连续显示的页数等等
        PageInfo pageInfo = new PageInfo(emps, 5);
        return Msg.success().add("pageInfo", pageInfo);
    }

    /**
     * 员工保存
     * 接收 /emp 的请求，但仅限于 POST 的请求， 表示增加信息类
     * 1、支持JSR303校验
     * 2、导入Hibernate-Validato
     */
    @RequestMapping(value = "/emp", method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult result) {


        if (result.hasErrors()) {
            //校验失败，应该返回失败，在模态框中显示校验失败的错误信息
            Map<String, Object> map = new HashMap<>();
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError error : errors) {
                System.out.println("错误的字段名：" + error.getField());
                System.out.println("错误信息：" + error.getDefaultMessage());
                map.put(error.getField(), error.getDefaultMessage());
            }
            return Msg.failed().add("errorFields", map);
        } else if (!employeeService.checkuser(employee.getEmpName())) {
            System.out.println("错误的字段名：empName");
            System.out.println("错误信息：用户名不可用");
            Map<String, Object> map = new HashMap<>();
            map.put("empName", "用户名不可用");
            return Msg.failed().add("errorFields", map);
        } else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }

    @RequestMapping("/checkuser")
    @ResponseBody
    public Msg checkuser(@RequestParam("empName") String empName) {
        // 前后端一起验证用户名是否符合正则表达式的规则 即先验证是否符合规则之后
        // 再去查询数据库是否重复，否则直接查询显示可用，但是却是不符合正则规则的，
        // 就会导致出现empName文本框显示用户名可用之后点击保存，empName文本框又
        // 提示错误信息
        String regName = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if (!empName.matches(regName)) {
            return Msg.failed().add("va_msg", "姓名是6-16位字母 或 2-5位汉字！");
        }
        boolean b = employeeService.checkuser(empName);
        if (!b) {
            return Msg.failed().add("va_msg", "用户名不可用");
        }
        return Msg.success().add("va_msg", "用户名可用");
    }

    /**
     * 根据Id查询员工
     *
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{id}", method = RequestMethod.GET)
    public Msg getEmp(@PathVariable("id") Integer id) {
        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("emp", employee);
    }

    /**
     * 更新员工信息
     * 『问题-Ajax发送PUT请求引发的血案』
     * 1. 当页面以PUT方式发送ajax请求的时候，控制器方法并没有正确的把请求封装到
     * 参数Employee对象中，除了路径参数empId之外其他的属性全为null，这就导致
     * 到 employee.xml配置文件中updateEmp是拼接sql更新语句得到的是
     * update t_emp where emp_id = 1001
     * 所以会出现sql语句的语法错误
     * <p>
     * 2. Tomcat 本来会将 POST 请求的表单数据封装到一个map中，然后SpringMVC通过
     * request.getParam("xx")方式得到请求体的参数，然后再创建Employee对象实现
     * set注入。但是Tomcat 并不会将 PUT 的请求体也封装到map中，这就导致SpringMVC
     * 在将请求体中的参数封装到employee对象的时候全为null 的情况。
     * <p>
     * 3. 解决既可以支持发送PUT请求，又可以正确的封装对象：
     * 在web.xml中配置HttpPutFormContextFilter过滤器『是SpringMVC框架提供的』
     * 原理： 这个过滤器类中检测如果是PUT请求，就会将它的请求体封装到一个map对象中，
     * 并根据这个map来构造request对象重写它的getParameter方法，这样就可以
     * 正确的封装employee对象了
     *
     * @param employee 路径中的参数也会按照参数名封装到employee对象中
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}", method = RequestMethod.PUT)
    public Msg updateEmp(Employee employee) {
//        System.out.println("获取请求体信息：" + request.getParameter("gender"));
//        System.out.println("将要更新的员工信息：" + employee);
        employeeService.updateEmp(employee);
        return Msg.success();
    }


    /**
     *  删除升级版：同时满足单独删除一个 和 全部删除多个
     *  问题：
     *  因为单独删除1个时候可以通过请求路径传过来一个Integer类型的Id值，然后根据主键进行删除
     *  但是如果多个的话，就不方便传递Integer类型，所以采用String类型的ids，采用间隔符的方式
     *  来判断是1个待删除还是全选多个
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{delIds}", method = RequestMethod.DELETE)
    public Msg deleteEmpById(@PathVariable("delIds") String delIds) {

        // 判断是单个删除还是多个删除
        if(delIds.contains("-")) {
            // 多个
            String[] str_ids = delIds.split("-");
            // 将id字符串数组封装成一个List<Integer>调用service方法进行处理
            List<Integer> list = new ArrayList<>();
            for (String str_id : str_ids) {
                list.add(Integer.parseInt(str_id));
            }
            employeeService.deleteAll(list);
        } else {
            int id = Integer.parseInt(delIds);
            employeeService.deleteEmpById(id);
        }


        return Msg.success();
    }

}
