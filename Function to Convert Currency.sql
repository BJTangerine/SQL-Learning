/* creates currency conversion function which accepts 2 parameters: dollar amount and exchange rate,
returns a numeric value with precision of 18 and 2 decimal places.
*/

CREATE FUNCTION dbo.ConvertDollar
	(@DollarAmt numeric(18,2),
     @ExchangeRate numeric(18,2))
RETURNS numeric(18,2)

AS

BEGIN
RETURN
	
	(SELECT @ExchangeRate * @DollarAmt)
END;