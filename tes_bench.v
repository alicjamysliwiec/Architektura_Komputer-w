module test_bench;

reg  [5:0] a, b;    // 6-bit wejscia
wire [5:0] s;       // 6-bit suma na wyjsciu
wire c6;     // przeniesienie - wyjscie z sumatora
reg [6:0] sprawdzenie;   // 6-bit wartosc do sprawdzenia poprawnosci
integer i, j;     // zmienne do obslugi petli
integer licz_poprawne; // licznik zawierajacy liczbe poprawnych wynikow dzialania sumatora
integer licz_bledne;   // licznik zawierajacy liczbe blednych wynikow dzialania sumatora

sklansky_all sklansky(a, b, s, c6); // zainicjowanie 6-bitowego sumatora typu sklansky

// rozpoczecie sprawdzania
initial begin
  $display("Rozpoczynamy test...");
  // ustawienie licznikow na 0
  licz_poprawne = 0; licz_bledne = 0;
  // przechodzimy przez wszystkie mozliwe wartosci pierwszej i drugiej liczby
  for (i = 0; i < 64; i = i + 1) begin
    a = i; //ustawienie pierwszego sygnalu wejsciowego
    for (j = 0; j < 64; j = j + 1) begin
      b = j; //ustawienie drugiego sygnalu wejsciowego
      sprawdzenie = a + b; //dodanie dwoch liczb w celu sprawdzenia poprawnosci
       #1; //odczekanie chwili by sumator zdazyl dodac sygnaly
        if ({c6, s} == sprawdzenie) begin //porownanie wyjscia sumatora z prawidlowym wynikiem
          licz_poprawne = licz_poprawne + 1;
        end else begin
          licz_bledne = licz_bledne + 1;
          // wyswietlenie wyniku pracy sumatora w przypadku błędnego wyniku
          $display($time, " %b + %b + = %b (%b)", a, b, {c6, s}, sprawdzenie);
        end
    end
  end
  // wyswietlenie liczby prawidlowych i blednych dodawan
  $display("Prawidlowe = %d, bledne = %d", licz_poprawne, licz_bledne);
  $finish;
end
endmodule
