<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="WebApplication1.WebForm1" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Data Analysis Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    
    <style>
        body {
            background: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }
        .sidebar {
            width: 250px;
            background: #343a40;
            color: white;
            padding: 20px;
            display: flex;
            flex-direction: column;
        }
        .sidebar h3 {
            text-align: center;
            margin-bottom: 30px;
            font-weight: bold;
        }
        .sidebar a {
            color: white;
            text-decoration: none;
            padding: 10px;
            display: block;
            border-radius: 5px;
            margin-bottom: 10px;
            transition: background 0.3s;
        }
        .sidebar a:hover {
            background: #495057;
        }
        .content {
            flex-grow: 1;
            padding: 30px;
        }
        .card {
            border-radius: 12px;
            box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }
        .btn-custom {
            width: 100%;
            font-weight: bold;
            transition: 0.3s;
        }
        .btn-custom:hover {
            transform: translateY(-3px);
        }
        canvas {
            max-width: 100%;
            height: 400px;
        }
    </style>
</head>
<body>

    <form id="form1" runat="server">
        <div class="dashboard-container">
            <!-- Sidebar -->
            <div class="sidebar">
                <h3>Data Analysis</h3>
                <a href="#">📊 Dashboard</a>
                <a href="#">📈 Charts</a>
                <a href="#">📂 Import Data</a>
                <a href="#">⚙ Settings</a>
            </div>

            <!-- Main Content -->
            <div class="content">
                <h2 class="mb-4">Data Analysis Dashboard</h2>
                
                <div class="row">
                    <!-- File Upload Section -->
                    <div class="col-md-4">
                        <div class="card">
                            <h5>📂 Upload File</h5>
                            <asp:FileUpload ID="fileUpload" runat="server" CssClass="form-control mt-2" />
                            <asp:Button ID="BtnUpload" runat="server" CssClass="btn btn-primary btn-custom mt-3" Text="Import Data" OnClick="BtnUpload_Click" />
                        </div>
                    </div>

                    <!-- Statistical Results -->
                    <div class="col-md-8">
                        <div class="card">
                            <h5>📊 Statistical Analysis</h5>
                            <p><strong>Mean:</strong> <asp:Label ID="lblMean" runat="server" Text="-" /></p>
                            <p><strong>Median:</strong> <asp:Label ID="lblMedian" runat="server" Text="-" /></p>
                            <p><strong>Mode:</strong> <asp:Label ID="lblMode" runat="server" Text="-" /></p>
                            <p><strong>Standard Deviation:</strong> <asp:Label ID="lblStdDev" runat="server" Text="-" /></p>
                        </div>
                    </div>
                </div>

                <!-- Chart Display -->
                <div class="card mt-4">
                    <h5>📈 Data Visualization</h5>
                    <canvas id="chartCanvas"></canvas>
                </div>

                <!-- Save Analysis -->
                <div class="mt-3">
                    <asp:Button ID="BtnSave" runat="server" CssClass="btn btn-success btn-custom" Text="Save Analysis" OnClick="BtnSave_Click" />
                </div>
            </div>
        </div>
    </form>

    <script>
        function renderChart(labels, data) {
            var ctx = document.getElementById('chartCanvas').getContext('2d');
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Data Analysis',
                        data: data,
                        backgroundColor: 'rgba(54, 162, 235, 0.2)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        }
    </script>

</body>
</html>