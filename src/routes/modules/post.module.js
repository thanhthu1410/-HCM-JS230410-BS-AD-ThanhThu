import express from "express";
const router = express.Router();
import fs from "fs"
import path from "path";

router.get("/", (req, res) => {

    fs.readFile(path.join(__dirname, "posts.json"), 'utf-8', (err, data) => {
        if (err) {
            return res.status(500).json(
                {
                    message: "failed",
                }
            )
        }
        if (req.query.id) {
            let post = JSON.parse(data).find(post => post.id == req.query.id);
            if (post) {
                return res.status(200).json(
                    {
                        data: post
                    }
                )
            } else{
                return res.status(500).json(
                   {
                    message : "Can not find post  " + req.query.id
                   }
                )
                  
                
            }
        }

        return res.status(200).json(
            {
                message: "success",
                data: JSON.parse(data)
            }
        )
    })
})
router.delete('/:postId', (req, res) => {
    if (req.params.postId) {
        fs.readFile(path.join(__dirname, "posts.json"), 'utf-8', (err, data) => {
            if (err) {
                return res.status(500).json({
                    message: "Lấy post thất bại!"
                })
            }
            let posts = JSON.parse(data);
            posts = posts.filter(post => post.id != req.params.postId);

            fs.writeFile(path.join(__dirname, "posts.json"), JSON.stringify(posts), (err) => {
                if (err) {
                    return res.status(500).json({
                        message: "Lưu file thất bại!"
                    })
                }
                return res.status(200).json({
                    message: "Xóa post thành công!"
                })
            })
        })
    } else {
        return res.status(500).json(
            {
                message: "Vui lòng truyền postId!"
            }
        )
    }
})
router.post('/', (req, res) => {

    fs.readFile(path.join(__dirname, "posts.json"), 'utf-8', (err, data) => {
        if (err) {
            return res.status(500).json(
                {
                    message: "Đọc dữ liệu thất bại!"
                }
            )
        }

        let oldData = JSON.parse(data);
        let newData = {
            userId : 10,
            id: Date.now(),
            title: req.body['title'],
            body: req.body['body']
        }
        oldData.push(newData)

        fs.writeFile(path.join(__dirname, "posts.json"), JSON.stringify(oldData), (err) => {
            if (err) {
                return res.status(500).json(
                    {
                        message: "Ghi file thất bại!"
                    }
                )
            }
            res.status(200).json({
                message: "Add post success!",
                data : data
            })
        })
    })

})

router.patch("/:id", (req, res) => {
    fs.readFile(path.join(__dirname, "posts.json"), 'utf-8', (err, data) => {

        const dataObj = JSON.parse(data)
        let postPatch;
        if (req.params.id) {
            let flag = false
         const   newDataObj = dataObj.map((post) => {
                if (post.id == req.params.id) {
                    flag = true;
                    postPatch = {
                        ...post,
                        ...req.body
                    }
                    return  {
                        ...post,
                        ...req.body
                    }
                }
                return post
            })
        
            fs.writeFile(path.join(__dirname, "posts.json"), JSON.stringify(newDataObj), (err) => {
                if (err) {
                    return res.status(500).json(
                        {
                            message: "Ghi file thất bại!"
                        }
                    )
                }
                return 
            })
            if (!flag) {
                return res.status(500).json({
                    message: req.params.id + " - khong ton tai "
                })
            }

        
            return res.status(200).json(
                {
                    message: "patch thanh cong" + req.params.id,
                    data: postPatch
                })
        }

    })
})


module.exports = router;