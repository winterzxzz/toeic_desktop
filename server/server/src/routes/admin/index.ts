import express, { NextFunction, Request, Response } from "express";
import { UserType } from "../../configs/interface";
import adminAuthRouter from "./auth";
import adminTransactionRouter from "./transaction";
import adminBlogRouter from "./blog";
import adminAnalysisRouter from "./analysis";
import adminUserRouter from "./user";
import adminTestRouter from "./test";
import adminResultRouter from "./result";
import adminCloudinaryRouter from "./cloudinary";
const routerA = express.Router();
routerA.use("/auth", adminAuthRouter);
routerA.use("/transaction", adminTransactionRouter);
routerA.use("/blog", adminBlogRouter);
routerA.use("/analysis", adminAnalysisRouter);
routerA.use("/user", adminUserRouter);
routerA.use("/test", adminTestRouter);
routerA.use("/result", adminResultRouter);
routerA.use("/cloudinary", adminCloudinaryRouter);
export default routerA;