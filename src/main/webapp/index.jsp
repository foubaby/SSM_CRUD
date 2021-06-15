<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>员工列表</title>

    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <script type="text/javascript"
            src="${APP_PATH }/static/js/jquery-3.4.1.js">
    </script>
    <link
            href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
            rel="stylesheet">
    <script
            src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js">

    </script>
</head>
<body>
<!-- 搭建显示页面 -->
<div class="container">
    <!-- 标题 -->
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>

    <!-- 按钮 -->
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
        </div>
    </div>

    <!-- 员工添加的模态框 -->
    <div class="modal fade" id="empAddModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="MyModalLabel">员工添加</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">姓名</label>
                            <div class="col-sm-10">
                                <input type="text" name="empName" class="form-control" id="empName_add_input"
                                       placeholder="empName">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">邮箱</label>
                            <div class="col-sm-10">
                                <input type="text" name="email" class="form-control" id="email_add_input"
                                       placeholder="email@abc.com">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">性别</label>
                            <div class="col-sm-10">
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender1_add_input" value="M"
                                           checked="checked"> 男
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender2_add_input" value="W"> 女
                                </label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">部门</label>
                            <div class="col-sm-4">
                                <%--     部门提交 得Ajax请求查询数据库之后才能显示所有的部门信息--%>
                                <select class="form-control" name="dId">
                                </select>
                            </div>

                        </div>

                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-primary" id="save_emp_btn">保存</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->

    <!-- 员工更新的模态框 -->
    <div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">员工更新</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">姓名</label>
                            <div class="col-sm-10">
                                <p class="form-control-static" id="empName_update_static"></p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">邮箱</label>
                            <div class="col-sm-10">
                                <input type="text" name="email" class="form-control" id="email_update_input"
                                       placeholder="email@abc.com">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">性别</label>
                            <div class="col-sm-10">
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender1_update_input" value="M"
                                           checked="checked"> 男
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender2_update_input" value="W"> 女
                                </label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">部门</label>
                            <div class="col-sm-4">
                                <%--     部门提交 得Ajax请求查询数据库之后才能显示所有的部门信息--%>
                                <select class="form-control" name="dId">
                                </select>
                            </div>

                        </div>

                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-primary" id="update_emp_btn">更新</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->

    <!-- 显示表格数据 -->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="check_all"/>
                    </th>
                    <th>#</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>

                </tbody>

            </table>
        </div>
    </div>

    <!-- 显示分页信息 -->
    <div class="row">
        <!--分页文字信息  -->
        <div class="col-md-6" id="page_info_area">
        </div>
        <!-- 分页条信息 -->
        <div class="col-md-6" id="page_nav_area">
        </div>
    </div>

</div>

<script type="text/javascript">

    var totalRecord, currentPage;

    //1、页面加载完成以后，直接去发送ajax请求,要到分页数据
    $(function () {
        //去首页
        to_page(1);
    });

    // Ajax请求显示页码数据
    function to_page(pn) {
        $.ajax({
            url: "${APP_PATH}/emps",
            data: "pn=" + pn,
            type: "GET",
            success: function (result) {
                // var list = result.extend.pageInfo.list;
                // console.log(result);
                // $.each(list, function (index, item){
                //     alert(item.empName);
                // })
                build_emps_table(result);
                build_page_info(result);
                build_page_navi(result);

            }
        });
    }

    // 构建table表中记录数据
    function build_emps_table(result) {
        // 每次显示页面数据的时候把上次append到tbody的先清空掉。
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        $.each(emps, function (index, item) {
            var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var genderTd = $("<td></td>").append(item.gender == 'M' ? "男" : "女");
            var empEmailTd = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.department.deptName);

            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn").append("编辑")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil"));

            // 为编辑按钮添加一个自定义的属性，来表示当前员工id,这样在点击之后可以根据此id对指定的
            // 用户的信息进行更新
            editBtn.attr("edit_id", item.empId);

            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm del_btn").append("删除")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash"));
            delBtn.attr("del_id", item.empId);

            var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);

            $("<tr></tr>").append(checkBoxTd)
                .append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(empEmailTd)
                .append(deptNameTd)
                .append(btnTd)
                .appendTo("#emps_table tbody");

        })
    };

    // 构建页码信息『左下』
    function build_page_info(result) {
        $("#page_info_area").empty();
        var info = result.extend.pageInfo;
        $("#page_info_area").append("当前" + info.pageNum + " 页,总共" + info.pages + "页,总" + info.total + " 条记录")
        totalRecord = info.total;
        currentPage = info.pageNum;
    };

    // 构建页码条数信息『右下』
    function build_page_navi(result) {
        $("#page_nav_area").empty();
        var info = result.extend.pageInfo;
        var navi_pages = info.navigatepageNums;

        var ul = $("<ul></ul>").addClass("pagination");
        //构建元素
        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页"));
        var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
        //nextPageLi = $("<li></li>").append($("<a></a>").attr("href", "#").append("%raquo"));
        // 禁用 或 添加点击事件实现翻页
        if (info.hasPreviousPage == false) {
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        } else {
            firstPageLi.click(function () {
                to_page(1);
            });
            prePageLi.click(function () {
                to_page(info.pageNum - 1)
            });
        }

        // 构建元素
        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页"));
        // 禁用 或 添加点击事件实现翻页
        if (info.hasNextPage == false) {
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        } else {
            nextPageLi.click(function () {
                to_page(info.pageNum + 1);
            });
            lastPageLi.click(function () {
                to_page(info.pages)
            });
        }

        ul.append(firstPageLi).append(prePageLi);
        $.each(navi_pages, function (index, item) {
            var numLi = $("<li></li>").append($("<a></a>").append(item));
            if (item == info.pageNum) {
                // 当前页高亮显示
                numLi.addClass("active");
            } else {
                // 给页码条添加点击事件发起Ajax请求
                numLi.click(function () {
                    to_page(item);
                })
            }
            ul.append(numLi);
        });
        ul.append(nextPageLi).append(lastPageLi);
        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    };

    // 发出Ajax请求得到全部的部门信息来构造Option 标签
    function getDepts(ele) {
        // 将之前添加至select单选框中的select去除， 否则会重复添加
        $(ele).empty();
        $.ajax({
            url: "${APP_PATH}/depts",
            type: "GET",
            async: false,
            success: function (result) {
                //console.log(result);
                var depts = result.extend.depts;
                // 每次循环往<select>标签添加复选项标签的时候就先清空之前的标签
                // $("#empAddModal select")[0].reset();
                $.each(depts, function () {
                    /*$("<option></option>").append(this.deptName)
                        .attr("value", this.deptId)
                        .appendTo($("#empAddModal select"));*/

                    var optionEle = $("<option></option>").append(this.deptName).attr("value", this.deptId);
                    optionEle.appendTo($(ele));

                })
            }
        });
    }

    // 清除表单数据及样式
    function clear_form(ele) {
        // 调用js原生的reset()将表单清空
        $(ele)[0].reset();
        // 将表单下所有标签的样式类去除
        $(ele).find("*").removeClass("has-error has-success");
        // 将表单下所有标签的提示信息置空
        $(ele).find(".help-block").text("");
    }

    // 显示校验结果的提示信息
    function show_validate_msg(ele, status, msg) {
        //清除当前元素的校验状态
        $(ele).parent().removeClass("has-success has-error");
        $(ele).next("span").text("");
        if ("success" == status) {
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
        } else if ("error" == status) {
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }

    // 利用正则表达式校验表单数据
    function validate_add_form() {
        var empName = $("#empName_add_input").val();
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;

        if (!regName.test(empName)) {
            // alert("姓名是6-16位字母 或 2-5位汉字！");
            // 美化错误提示信息
            // 因为姓名文本框内容一改变就会进行ajax请求验证是否可用，并且在后端也进行验证正则规则
            //show_validate_msg("#empName_add_input", "error", "姓名是6-16位字母 或 2-5位汉字！");
            return false;
        } else {
            show_validate_msg("#empName_add_input", "success", "");
        }

        var email = $("#email_add_input").val();
        var regEmail = /^([a-zA-Z0-9_\.-]+)@([\da-zA-Z\.-]+)\.([a-zA-Z\.]{2,6})$/;
        if (!regEmail.test(email)) {
            //alert("不符合电子邮件的格式！");
            show_validate_msg("#email_add_input", "error", "不符合电子邮件的格式！");
            return false;
        } else {
            show_validate_msg("#email_add_input", "success", "");
        }

        return true;
    }

    // 根据id发Ajax请求得到用户信息,填充更新模态框
    function getEmp(id) {
        $.ajax({
            url: "${APP_PATH}/emp/" + id,
            type: "GET",
            success: function (result) {
                console.log(result);
                var empData = result.extend.emp;
                // 因为添加模态框是在jsp页面代码中写好的，所以这些标签是创建好了，只是没有显示罢了
                // 所以可以进行添加内容 和 页面加载过程中给其添加事件
                $("#empName_update_static").text(empData.empName);
                $("#email_update_input").val(empData.email);
                // 因为单选按钮的值为 empData.gender 类型
                $("#empUpdateModal input[name=gender]").val([empData.gender]);
                // 因为单选框option的值为 empData.dId 类型， 类似Enum枚举，
                // 我们通过提供value就能决定选中哪一个
                //$("#empUpdateModal select").find("option[value=" + empData.dId + "]").prop("selected", true);
                $("#empUpdateModal select").val(empData.dId);
            }
        });
    }

    // 点击 新增 按钮弹出模态框
    $("#emp_add_modal_btn").click(function () {
        // 每次点击新增之前，应该把之前的表单置空，以及提示信息
        clear_form("#empAddModal form");

        // 弹出模态框之前应该发送Ajax请求，查出所有的部门信息，显示在下拉列表中
        // 此时虽然模态框还没有弹出，但是已经创建好了，所以是可以进行填充select的
        getDepts("#empAddModal select")

        // 然后再弹出模态框
        $("#empAddModal").modal({
            // 防止点击背景会关闭模态框
            backdrop: "static"
        });

    });

    // 为模态框的 save_emp_btn 按钮添加点击事件，发送Ajax请求实现添加用户
    // 点击保存，保存员工。
    $("#save_emp_btn").click(function () {
        // 1. 先对要提交给服务器的数据进行正则表达式的校验，这里是进行前端校验
        if (!validate_add_form()) {
            return false;
        }

        // 2. 通过按钮上的自定义属性 ajax-va 校验用户名是否可用
        if ($(this).attr("ajax-va") == "error") {
            show_validate_msg("#empName_add_input", "error", $(this).attr("va_msg"));
            return false;
        }
        /*else {
            show_validate_msg("#empName_add_input", "success", "");
        }*/

        // 3. 全部表单数据校验成功之后再发起 Ajax 保存请求
        $.ajax({
            url: "${APP_PATH}/emp",
            type: "POST",
            // js 提供的方法serialize 可以实现表单数据的序列化，以类似地址栏参数的方式进行拼接
            data: $("#empAddModal form").serialize(),
            success: function (result) {
                // 弹框显示提示信息
                alert(result.msg);

                if (result.code == 100) {
                    /*添加成功之后做两个工作：
                    1. 关闭模态框
                    2. 跳转到最后一页，可以看到刚添加的信息
                       怎么解决跳到最后一页？
                       可以在 js 中设置一个全局变量 totalRecord 每当构建页码信息的时候就更新它为
                       当前总记录数，这样我们直接以总的记录数当作最后一页，因为PageHelper插
                       件有页码合理性校验，所以总会显示最后一页的内容*/
                    $('#empAddModal').modal('hide');
                    to_page(totalRecord);
                } else {
                    // 首先前端校验是假验证，实际上是可以越过前端验证而发起请求的，比如
                    // 在前端篡改页面上的保存按钮上的属性ajax-va，即我们在验证用户名是否
                    // 可用时添加的自定义属性，也可以执行用户添加操作，但是破坏了数据库
                    // 数据的安全性，
                    // 因此涉及重要的数据的保存、更新我们都需要同时在后端进行验证，防止用户
                    // 前端篡改了页面
                    //console.log(result);
                    //alert(errors.email);
                    //alert(errors.empName);
                    var errors = result.extend.errorFields;
                    if (errors.email != undefined) {
                        // 说明 email 字段发生了错误
                        show_validate_msg("#email_add_input", "error", errors.email);
                    }
                    if (errors.empName != undefined) {
                        // 说明 empName 字段发生了错误
                        show_validate_msg("#empName_add_input", "error", errors.empName);
                    }

                }
            }

        });


    });

    // 2. 利用 Ajax 请求校验表单输入的用户名是否可用
    //    为用户名输入表单添加change事件，一改变内容就触发
    $("#empName_add_input").change(function () {
        var empName = this.value;
        $.ajax({
            url: "${APP_PATH}/checkuser",
            data: "empName=" + empName,
            type: "POST",
            success: function (result) {
                if (100 == result.code) {
                    show_validate_msg("#empName_add_input", "success", result.extend.va_msg);
                    // 只是在 change 之后发起校验用户名是否可用给出提示信息，但是在保存的时候只会
                    // 按照正则表达式进行验证且通过，一样可以添加，这样没有效果 因此在保存按钮的
                    // Dom对象中添加一个自定义属性 用来标识校验的用户名是否可用
                    $("#save_emp_btn").attr("ajax-va", "success").attr("va_msg", result.extend.va_msg);
                } else {
                    // result.code == 200 错误又分为是验证正则错误 还是 验证重复名错误，因此
                    // 错误提示信息不能写死，保存在返回的Msg的附加信息中
                    show_validate_msg("#empName_add_input", "error", result.extend.va_msg);
                    $("#save_emp_btn").attr("ajax-va", "error").attr("va_msg", result.extend.va_msg);
                }
            }

        })
    });

    /*为table表中每条记录的编辑按钮添加点击事件 但是普通的利用选择器.click()
    方法是添加不了点击事件的，因为table表中每一个<tr>都是在页面加载完成之后
    发Ajax请求动态添加的，而我们给按钮添加点击事件是在页面加载『按照jsp代码』
    的时候进行的，此时按钮还没有创建，所以无效，因该选择一种方法可以为之后创建
    的标签添加点击事件 --> on
    $(".edit_btn").click(function (){
        alert("编辑");
    })*/
    // 点击编辑弹出模态框
    $(document).on("click", ".edit_btn", function () {
        // alert("edit");


        // 1. 查出员工信息，显示在模态框表单中
        // 注意： 因为1，2 都是异步发起请求来填充select标签，并设置选中，所以有时会出现冲突
        getEmp($(this).attr("edit_id"));

        // tip:将编辑按钮上的 edit_id 属性添加到保存按钮上，以备后面按主键进行保存
        $("#update_emp_btn").attr("edit_id", $(this).attr("edit_id"));

        // 2. 查出部门信息，显示在模态框select表单中
        // 注意：这里要求ajax请求填充select单选框不是异步发起请求，否则会导致将之前按用户id
        //       插到的信息赋值的option 被覆盖
        getDepts("#empUpdateModal select");


        // 3. 再弹出模态框
        $("#empUpdateModal").modal({
            // 防止点击背景会关闭模态框
            backdrop: "static"
        });
    });

    //点击更新，更新员工信息
    $("#update_emp_btn").click(function () {
        // 1. 先对用户填写的邮箱进行校验
        $("#empUpdateModal form").find("*").removeClass("has-error has-success");
        var email = $("#email_update_input").val();
        var regEmail = /^([a-zA-Z0-9_\.-]+)@([\da-zA-Z\.-]+)\.([a-zA-Z\.]{2,6})$/;
        if (!regEmail.test(email)) {
            //alert("不符合电子邮件的格式！");
            show_validate_msg("#email_update_input", "error", "不符合电子邮件的格式！");
            return false;
        }
        /*else {
            show_validate_msg("#email_update_input", "success", "");
        }*/

        // 2.发送 ajax 请求保存更新的员工的数据
        $.ajax({
            url: "${APP_PATH}/emp/" + $(this).attr("edit_id"),
            type: "PUT",
            data: $("#empUpdateModal form").serialize(),
            success: function (result) {
                // console.log(result);
                // 1. 更新完成之后，直接关闭模态框
                $("#empUpdateModal").modal("hide");
                // 2. 然后返回修改员工所在页查看
                to_page(currentPage);
            }
        });

    });

    // 为删除按钮添加点击事件
    // 编辑 和 删除按钮都是动态添加的标签，所以使用这种方式添加事件
    $(document).on("click", ".del_btn", function () {
        var empName = $(this).parents("tr").find("td:eq(2)").text();
        var empId = $(this).attr("del_id");
        if (confirm("确认删除【" + empName + "】吗？")) {
            // 确认删除 则发起ajax请求进行删除
            $.ajax({
                url: "${APP_PATH}/emp/" + empId,
                type: "DELETE",
                success: function (result) {
                    alert(result.msg);
                    to_page(currentPage);
                }
            })
        }

    });

    // 给table表头中的全选/全不选复选框添加点击事件
    /*
        注意： 1. 当给<body>标签中定义好的标签添加事件的时候可以使用.click(function(){})
               的方式，因为创建标签 与 添加事件都是在页面加载过程中进行的
               2. 当给页面加载完成之后，通过js方法后来创建的标签添加事件函数的时候使用
               .check()方法是没有效果的，因为添加事件的方法并不是在$(function(){...})里
               页面加载完成之后进行的，而是页面加载过程中进行的，此时那些标签还没有创建，
               因此点击事件不会添加进去，我们应该使用的是.on方法可以给后面创建的同name、
               id、class属性的标签添加方法
     */
    // 全选框是页面加载过程中已经存在的
    $("#check_all").click(function () {
        //attr获取checked是undefined;
        //我们这些dom原生的属性；attr获取自定义属性的值；
        //prop修改和读取dom原生属性的值
        var tag = $(this).prop("checked");
        $(".check_item").prop("checked", tag);
    });

    // 给每个<tr>中的复选框添加点击事件
    // 它们是在页面加载完成之后通过ajax请求动态添加的标签
    $(document).on("click", ".check_item", function () {
        // 如果本页全部都被选中，那么全选复选框也应该被选中
        var tag = $(".check_item:checked").length == $(".check_item").length;
        $("#check_all").prop("checked", tag);
    });

    // 点击全部删除，实现批量删除
    $("#emp_delete_all_btn").click(function(){

        var empNames = "";
        var delIds = "";
        $.each($(".check_item:checked"),function(){
            //alert($(this).parents("tr").find("td:eq(2)").text());
            //this
            empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
            //组装员工id字符串
            delIds += $(this).parents("tr").find("td:eq(1)").text()+"-";
        });
        // 字符串去除末尾多余的, 和 -
        empNames = empNames.substring(0, empNames.length-1);
        delIds = delIds.substring(0, delIds.length-1);

        if(confirm("确认删除【" + empNames + "】吗？")){
            // 确认删除，发起请求
            $.ajax({
               url:"${APP_PATH}/emp/" + delIds,
               type:"DELETE",
               success:function (result) {
                   alert(result.msg);
                   to_page(currentPage);
                   // 如果是全选删除，跳转当前页之后，此时全选应该不被选中
                   $("#check_all").prop("checked", false);
               }
            });
        }

    });




</script>
</body>
</html>
