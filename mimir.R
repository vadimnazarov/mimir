library(grid)
library(gridBase)
library(gridExtra)
library(tcR)
library(jsonlite)

setwd("~/Projects/mimir/")

var_json <- list.files("./data_exp/variable length/", "var", full.names = T)
const_json <- list.files("./data_exp/", "const1", full.names = T )

tw_names = c("A1", "A2", "C1", "C2", "D1", "D2")
tw_sizes = c(211877, 110505, 457362, 396307, 350623, 397691)

grid_arrange_shared_legend <- function(...) {
  plots <- list(...)
  g <- ggplotGrob(plots[[1]] + theme(legend.position="bottom"))$grobs
  
  legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
  
  lheight <- sum(legend$height)
  arrangeGrob(
    do.call(arrangeGrob, lapply(plots, function(x)
      x + theme(legend.position="none"))),
    legend,
    ncol = 1,
    # heights = unit.c(unit(.95, "npc") - lheight, lheight), top = "Зависимость логарифма правдоподобия от числа итераций")
    heights = unit.c(unit(.95, "npc") - lheight, lheight), top = "Log-likelihood ~ iterations")
}


load_logs <- function () {
  logs <- list()
  for (file in list.files("data_log/", full.names = T)) {
    spl <- strsplit(file, ".", T)[[1]]
    log_vec <- readLines(file)[-c(1:5)]
    log_vec <- log_vec[-c(length(log_vec) - 1, length(log_vec))]
    log_vec = as.numeric(sapply(strsplit(log_vec, " ", T), "[[", 2))
    
    name = strsplit(spl[[1]], "//", T)[[1]][2]
    algo = spl[[2]]
    
    if (algo != "const5") {
      logs[[name]][[algo]] = data.frame(Iter = 1:length(log_vec), logL = log_vec)
    }
  }
  
  logs <- lapply(logs, function (x) { 
    x <- melt(x, id.vars = c("Iter", "logL"))
    names(x) = c("Iter", "logL", "Algo")
    x
  } )
  
  names(logs) = c("A1", "A2", "C1", "C2", "D1", "D2")
  pls <- list()
  for (tw in names(logs)) {
    p = ggplot() + geom_line(aes(x = Iter, y = logL, colour = Algo, linegroup = Algo), data = logs[[tw]]) + 
      theme_linedraw() + 
      ggtitle(tw) +
      # xlab("Итерация") +
      xlab("Iteration") + 
      theme(legend.position="none") + scale_color_discrete(
        # name="Градиентный спуск",
        name="Gradient descent",
        breaks=c("const_5", "const1", "const2", "var"),
        # labels=c("шаг 0.5", "шаг 1.0", "шаг 2.0", "переменный шаг"))
      labels=c("step=0.5", "step=1.0", "step=2.0", "variable step"))
    
    pls <- c(pls, list(p))
  }
  
  do.call(grid_arrange_shared_legend, pls)
}


plot_aa <- function (.file = "./data_exp/") {
  json <- jsonlite::fromJSON(.file); 
  pls <- list(); 
  for (aa in names(json$q_Li)) { 
    tmp <- json$q_Li[[aa]]; 
    tmp[tmp==0] <- NA; 
    row.names(tmp) <- as.character(1:nrow(tmp))
    colnames(tmp) <- as.character(1:ncol(tmp))
    pls <- c(pls, list(vis.heatmap(tmp, .text = F, .legend = "q", .title=aa, .no.legend = T, .no.labs = T))) 
  }; 
  do.call(arrangeGrob, c(pls, list(nrow = 4, top = "A")))
}


plot_len <- function (.files) {
  p <- ggplot()
  for (f in .files) {
    if (length(grep("const5", f)) == 0) {
      json <- jsonlite::fromJSON(f); 
      tmp <- data.frame(qL = as.numeric(json$L$qL), L = as.numeric(json$L$minL):as.numeric(json$L$maxL), File = f)
      p <- p + geom_point(aes(x = L, y = qL, colour = File), data = tmp) + geom_line(aes(x = L, y = qL, colour = File), data = tmp)
    }
  }
  p +  theme_linedraw()
}


plot_qvj <- function (.files = list.files("./data_exp/", "var", full.names = T)) {
  n = length(.files)
  res <- matrix(NA, n, n)
  for (i in 1:n) {
    for (j in 1:n) {
      if (i != j) {
        tmp1 <- jsonlite::fromJSON(.files[i])$VJ$q_VJ;
        # tmp1[tmp1 == 0] = NA
        tmp2 <- jsonlite::fromJSON(.files[j])$VJ$q_VJ;
        # tmp2[tmp2 == 0] = NA
        res[i, j] = js.div(as.vector(tmp1), as.vector(tmp2))
      }
    }
  }
  vis.heatmap(res)
}


plot_qcors <- function () {
  n = length(var_json)
  pls <- list(); 
  cors = c()
  for (i in 1:n) { 
    tmp1 <- unlist(jsonlite::fromJSON(var_json[i])$q_Li); 
    tmp2 <- unlist(jsonlite::fromJSON(const_json[i])$q_Li); 
    logic <- tmp1 != 0 & tmp2 != 0
    tmp1 = tmp1[logic]
    tmp2 = tmp2[logic]
    df = data.frame(Var = tmp1, Const = tmp2, Div = log(tmp1 / tmp2))
    min_val = -1
    max_val = 1
    df$Div[df$Div > max_val] = max_val
    df$Div[df$Div < min_val] = min_val
    cors = c(cors, round(cor(df$Var, df$Const), 4))
    
    lo = 0
    hi = 2
    
    p = ggplot() + 
      geom_point(aes(x = Var, y = Const, fill = Div), size = 2, shape = 21, data = df) + 
      geom_abline(intercept = 0, slope = 1, linetype = "dashed") + 
      geom_label(aes(x = hi, y = lo), hjust = -(lo - hi) / 2.1, vjust = -(lo - hi) / 8, label = cors[i]) +
      theme_linedraw() + 
      ggtitle(paste0(tw_names[i], " (", tw_sizes[i], ")")) + 
      # coord_fixed(xlim = c(lo, hi), ylim=c(lo, hi)) + xlab("q (перем. шаг)") + ylab("q (конст. шаг)") + 
      coord_fixed(xlim = c(lo, hi), ylim=c(lo, hi)) + xlab("q (var. step)") + ylab("q (const. step)") + 
      .colourblind.gradient(.min = min_val, .max = max_val, F) +
      theme(legend.position = "none")
    pls <- c(pls, list(p)) 
  }; 
  # do.call(arrangeGrob, c(pls, list(nrow = 2, top = "Совместные распределения параметров моделей селекции, полученные разными алгоритмами (аминокислоты)")))
  do.call(arrangeGrob, c(pls, list(nrow = 2, top = "Amino acids")))
}


plot_vjcors <- function () {
  n = length(var_json)
  pls <- list(); 
  cors = c()
  for (i in 1:n) { 
    tmp1 <- unlist(jsonlite::fromJSON(var_json[i])$VJ$q_VJ); 
    tmp2 <- unlist(jsonlite::fromJSON(const_json[i])$VJ$q_VJ); 
    logic <- tmp1 != 0 & tmp2 != 0
    tmp1 = tmp1[logic]
    tmp2 = tmp2[logic]
    df = data.frame(Var = tmp1, Const = tmp2, Div = log(tmp1 / tmp2))
    min_val = -.2
    max_val = .2
    df$Div[df$Div > max_val] = max_val
    df$Div[df$Div < min_val] = min_val
    cors = c(cors, round(cor(df$Var, df$Const), 4))
    
    lo = .2
    hi = 1.7
    
    p = ggplot() + 
      geom_point(aes(x = Var, y = Const, fill = Div), size = 2, shape = 21, data = df) + 
      geom_abline(intercept = 0, slope = 1, linetype = "dashed") + 
      geom_label(aes(x = hi, y = lo), hjust = -(lo - hi) / 1.6, vjust = -(lo - hi) / 8, label = cors[i]) +
      theme_linedraw() + 
      ggtitle(paste0(tw_names[i], " (", tw_sizes[i], ")")) + 
      # coord_fixed(xlim = c(lo, hi), ylim=c(lo, hi)) + xlab("q (перем. шаг)") + ylab("q (конст. шаг)") + 
      coord_fixed(xlim = c(lo, hi), ylim=c(lo, hi)) + xlab("q (var. step)") + ylab("q (const. step)") + 
      .colourblind.gradient(.min = min_val, .max = max_val, F) +
      theme(legend.position = "none")
    pls <- c(pls, list(p)) 
  }; 
  # do.call(arrangeGrob, c(pls, list(nrow = 2, top = "Совместные распределения параметров моделей селекции, полученные разными алгоритмами (гены)")))
  do.call(arrangeGrob, c(pls, list(nrow = 2, top = "Genes")))
}


plot_lencors <- function () {
  n = length(var_json)
  pls <- list(); 
  cors = c()
  for (i in 1:n) { 
    tmp1 <- unlist(jsonlite::fromJSON(var_json[i])$L$qL); 
    tmp2 <- unlist(jsonlite::fromJSON(const_json[i])$L$qL); 
    logic <- tmp1 != 0 & tmp2 != 0
    tmp1 = tmp1[logic]
    tmp2 = tmp2[logic]
    df = data.frame(Var = tmp1, Const = tmp2, Div = log(tmp1 / tmp2))
    min_val = -.1
    max_val = .1
    df$Div[df$Div > max_val] = max_val
    df$Div[df$Div < min_val] = min_val
    cors = c(cors, round(cor(df$Var, df$Const), 4))
    
    lo = .5
    hi = 1.3
    
    p = ggplot() + 
      geom_point(aes(x = Var, y = Const, fill = Div), size = 2, shape = 21, data = df) + 
      geom_abline(intercept = 0, slope = 1, linetype = "dashed") + 
      geom_label(aes(x = hi, y = lo), hjust = -(lo - hi) / .8, vjust = -(lo - hi) / 8, label = cors[i]) +
      theme_linedraw() + 
      ggtitle(paste0(tw_names[i], " (", tw_sizes[i], ")")) + 
      # coord_fixed(xlim = c(lo, hi), ylim=c(lo, hi)) + xlab("L (перем. шаг)") + ylab("L (конст. шаг)") + 
      coord_fixed(xlim = c(lo, hi), ylim=c(lo, hi)) + xlab("q (var. step)") + ylab("q (const. step)") + 
      .colourblind.gradient(.min = min_val, .max = max_val, F) +
      theme(legend.position = "none")
    pls <- c(pls, list(p)) 
  }; 
  # do.call(arrangeGrob, c(pls, list(nrow = 2, top = "Совместные распределения параметров моделей селекции, полученные разными алгоритмами (длина)")))
  do.call(arrangeGrob, c(pls, list(nrow = 2, top = "Lengths")))
}