---
output:
  html_document: default
  word_document: default
  pdf_document: default
---

# The Hamlet Evaluation System - Reevaluated
#### John T McCormick
#### 28 April 2021

---

### Introduction

The Hamlet Evaluation System (including its precursor HAMLA) was an attempt to quantify the pacification campaign in the US-Vietnam War. In a "war without fronts" the need for quantitative metrics to measure success was paramount. Throughout the war, hundreds of thousands of observations were collected and analyzed by Army Operations Researches and civilian contractors such as RAND. All these efforts aimed to answer the question, "*Was the US winning the war in Vietnam?*"

At the time and shortly after, many considered these metrics to be faulty, misguided and largely unsuccessful. Yet much of the historiography suggests that HES and other statistical survey techniques were not fully embraced. Crude efficiency measures such as body count and kill-death ratios are often described as the focus on commanders attempts to measure the war. If this is the case, why were more sophisticated systems such as the HES being ignored? Was the issue one of the systems themselves or officers ability to grasp statistical and geographically diffuse metrics? The simple fact is that almost no study of the Vietnam War has actually dived into the data to answer these questions. 

This analysis seeks to answer the above questions by applying modern data analytic and GIS techniques to understanding, modeling and communicating the data collected in the HES. The viability of a data-based approach to human-centric warfare is a critical question to the modern military as the armed forces are increasingly called to compete and influence below the threshold of conventional conflict. These types of "gray-zone" and "hybrid" conflicts will inherently be "wars without fronts" in the sense of a geographic line of control. This makes solving and understanding the problems of the US Army's previous attempts to model abstract conflict of vital importance to the modern military.

---

### File Structure

The data processing and manipulation will be handled in a R-project before being exported to separate directory for ArcGIS analysis. Additionally, presentation ready files, interim reports and process logs will be published to a Google Doc for communication and evaluation. 

`\HES_Reevaluated` - Main Directory for processing and analyzing Data
 
 - `\data` - Storage bin for raw, tidy and clean data
 - `\reports` - place for Markdown notebooks and presentation products
 - `\src` - place for script files and processing tools
 
 Google Drive - `\GIS_HES_Reevaluated` - Google Drive directory for presentation
 
 - `\Documenation` - Folder for proposal and process log
