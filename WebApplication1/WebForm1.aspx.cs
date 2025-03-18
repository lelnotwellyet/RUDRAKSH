using System;
using System.Data;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;

namespace WebApplication1
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void BtnUpload_Click(object sender, EventArgs e)
        {
            if (fileUpload.HasFile)
            {
                string filePath = Server.MapPath("~/Uploads/" + Path.GetFileName(fileUpload.FileName));
                fileUpload.SaveAs(filePath);

                DataTable dt = ReadCsvFile(filePath);
                if (dt != null && dt.Rows.Count > 0)
                {
                    PerformStatisticalAnalysis(dt);
                }
            }
        }

        private DataTable ReadCsvFile(string filePath)
        {
            DataTable dt = new DataTable();
            using (StreamReader sr = new StreamReader(filePath))
            {
                string line = sr.ReadLine();
                if (string.IsNullOrEmpty(line)) return null;

                string[] headers = line.Split(',');
                foreach (string header in headers)
                {
                    dt.Columns.Add(header.Trim());
                }

                while (!sr.EndOfStream)
                {
                    string[] rows = sr.ReadLine().Split(',');
                    dt.Rows.Add(rows);
                }
            }
            return dt;
        }

        private void PerformStatisticalAnalysis(DataTable dt)
        {
            // Find first numeric column
            string numericColumn = null;
            foreach (DataColumn col in dt.Columns)
            {
                if (dt.AsEnumerable().All(row => double.TryParse(row[col].ToString(), out _)))
                {
                    numericColumn = col.ColumnName;
                    break;
                }
            }

            if (numericColumn == null)
            {
                lblMean.Text = "N/A";
                lblMedian.Text = "N/A";
                lblMode.Text = "N/A";
                lblStdDev.Text = "N/A";
                return;
            }

            var numbers = dt.AsEnumerable().Select(row => Convert.ToDouble(row[numericColumn])).ToList();

            lblMean.Text = numbers.Average().ToString("F2");
            lblMedian.Text = GetMedian(numbers).ToString("F2");
            lblMode.Text = string.Join(", ", GetMode(numbers));
            lblStdDev.Text = GetStandardDeviation(numbers).ToString("F2");

            // Send data to JavaScript for chart rendering
            string labels = string.Join(",", numbers.Select((x, i) => $"'Data {i + 1}'"));
            string values = string.Join(",", numbers);

            ClientScript.RegisterStartupScript(this.GetType(), "renderChart", $"setTimeout(() => renderChart([{labels}], [{values}]), 500);", true);
        }

        private double GetMedian(List<double> numbers)
        {
            numbers.Sort();
            int count = numbers.Count;
            return count % 2 == 0 ? (numbers[count / 2 - 1] + numbers[count / 2]) / 2 : numbers[count / 2];
        }

        private List<double> GetMode(List<double> numbers)
        {
            var groups = numbers.GroupBy(n => n).OrderByDescending(g => g.Count());
            int maxCount = groups.First().Count();

            return groups.Where(g => g.Count() == maxCount).Select(g => g.Key).ToList();
        }

        private double GetStandardDeviation(List<double> numbers)
        {
            double avg = numbers.Average();
            double sumOfSquares = numbers.Sum(x => Math.Pow(x - avg, 2));
            return Math.Sqrt(sumOfSquares / numbers.Count);
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            string filePath = Server.MapPath("~/AnalysisResult.txt");
            File.WriteAllText(filePath, $"Mean: {lblMean.Text}\nMedian: {lblMedian.Text}\nMode: {lblMode.Text}\nStandard Deviation: {lblStdDev.Text}");

            Response.ContentType = "application/octet-stream";
            Response.AppendHeader("Content-Disposition", "attachment; filename=AnalysisResult.txt");
            Response.TransmitFile(filePath);
            Response.End();
        }
    }
}